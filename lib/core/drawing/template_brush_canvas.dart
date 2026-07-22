import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';

/// Coloring template with pinch/button zoom and finger-paint strokes.
class TemplateBrushCanvas extends StatefulWidget {
  const TemplateBrushCanvas({
    super.key,
    required this.svgAssetPath,
    required this.color,
    required this.strokeWidth,
    required this.strokes,
    required this.onStrokeComplete,
  });

  final String svgAssetPath;
  final Color color;
  final double strokeWidth;
  final List<SmoothStroke> strokes;
  final ValueChanged<SmoothStroke> onStrokeComplete;

  @override
  State<TemplateBrushCanvas> createState() => _TemplateBrushCanvasState();
}

class _TemplateBrushCanvasState extends State<TemplateBrushCanvas> {
  final _transform = TransformationController();
  List<DrawPoint>? _currentPoints;
  bool _moveMode = false;
  int _activePointers = 0;
  Size _canvasSize = Size.zero;
  String? _outlineSvg;

  @override
  void initState() {
    super.initState();
    _loadOutlineSvg();
  }

  @override
  void didUpdateWidget(covariant TemplateBrushCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgAssetPath != widget.svgAssetPath) {
      _loadOutlineSvg();
    }
  }

  Future<void> _loadOutlineSvg() async {
    final raw = await rootBundle.loadString(widget.svgAssetPath);
    if (!mounted) return;
    setState(() => _outlineSvg = _outlineOnlySvg(raw));
  }

  /// Transparent fills + visible black strokes for a top overlay layer.
  static String _outlineOnlySvg(String svg) {
    var result = svg.replaceAllMapped(
      RegExp(r'\bfill="[^"]*"', caseSensitive: false),
      (_) => 'fill="none"',
    );
    result = result.replaceAllMapped(
      RegExp(r'stroke-width="([\d.]+)"'),
      (match) {
        final width = double.tryParse(match.group(1) ?? '') ?? 2;
        final boosted = (width * 1.15).clamp(1.5, 4.0);
        return 'stroke-width="${boosted.toStringAsFixed(1)}"';
      },
    );
    return result.replaceAll(
      RegExp(r'stroke="#222"', caseSensitive: false),
      'stroke="#111111"',
    );
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  double get _scale => _transform.value.getMaxScaleOnAxis().clamp(1.0, 5.0);

  double get _sceneStrokeWidth => widget.strokeWidth / _scale;

  void _zoomBy(double factor) {
    if (_canvasSize == Size.zero) return;
    final focal = Offset(_canvasSize.width / 2, _canvasSize.height / 2);
    final sceneFocal = _transform.toScene(focal);
    final matrix = _transform.value.clone()
      ..translateByDouble(sceneFocal.dx, sceneFocal.dy, 0, 1)
      ..scaleByDouble(factor, factor, 1, 1)
      ..translateByDouble(-sceneFocal.dx, -sceneFocal.dy, 0, 1);
    _transform.value = matrix;
  }

  void _resetZoom() {
    _transform.value = Matrix4.identity();
  }

  void _toggleMoveMode() {
    setState(() {
      _moveMode = !_moveMode;
      _currentPoints = null;
    });
  }

  bool get _canPaint => !_moveMode && _activePointers == 1;

  void _onPointerDown(PointerDownEvent event) {
    _activePointers++;
    if (!_canPaint) return;
    _currentPoints = [DrawPoint(event.localPosition)];
    setState(() {});
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_canPaint || _currentPoints == null) return;
    setState(() => _currentPoints!.add(DrawPoint(event.localPosition)));
  }

  void _finishStroke() {
    if (_currentPoints == null || _currentPoints!.isEmpty) return;
    widget.onStrokeComplete(
      SmoothStroke(
        points: List.from(_currentPoints!),
        color: widget.color,
        strokeWidth: _sceneStrokeWidth,
      ),
    );
    _currentPoints = null;
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_canPaint) _finishStroke();
    _activePointers = (_activePointers - 1).clamp(0, 10);
    setState(() {});
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _currentPoints = null;
    _activePointers = (_activePointers - 1).clamp(0, 10);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        final liveStrokes = [
          ...widget.strokes,
          if (_currentPoints != null && _currentPoints!.isNotEmpty)
            SmoothStroke(
              points: _currentPoints!,
              color: widget.color,
              strokeWidth: _sceneStrokeWidth,
            ),
        ];

        return Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              transformationController: _transform,
              panEnabled: _moveMode,
              scaleEnabled: true,
              minScale: 1.0,
              maxScale: 5.0,
              clipBehavior: Clip.none,
              boundaryMargin: const EdgeInsets.all(48),
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: SizedBox(
                  width: _canvasSize.width,
                  height: _canvasSize.height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.white),
                      CustomPaint(
                        painter: FreeDrawPainter(strokes: liveStrokes),
                        size: _canvasSize,
                      ),
                      if (_outlineSvg != null)
                        Center(
                          child: IgnorePointer(
                            child: SvgPicture.string(
                              _outlineSvg!,
                              fit: BoxFit.contain,
                              width: _canvasSize.width,
                              height: _canvasSize.height,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ZoomChip(
                    icon: Icons.add_rounded,
                    label: 'Zoom in',
                    accent: accent,
                    onTap: () => _zoomBy(1.25),
                  ),
                  const SizedBox(height: 6),
                  _ZoomChip(
                    icon: Icons.remove_rounded,
                    label: 'Zoom out',
                    accent: accent,
                    onTap: () => _zoomBy(0.8),
                  ),
                  const SizedBox(height: 6),
                  _ZoomChip(
                    icon: Icons.fit_screen_rounded,
                    label: 'Fit',
                    accent: accent,
                    onTap: _resetZoom,
                  ),
                  const SizedBox(height: 6),
                  _ZoomChip(
                    icon: _moveMode
                        ? Icons.brush_rounded
                        : Icons.pan_tool_alt_rounded,
                    label: _moveMode ? 'Paint' : 'Move',
                    accent: _moveMode ? Colors.orange : accent,
                    selected: _moveMode,
                    onTap: _toggleMoveMode,
                  ),
                ],
              ),
            ),
            if (_scale > 1.05)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '${(_scale * 100).round()}%',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ZoomChip extends StatelessWidget {
  const _ZoomChip({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? accent.withValues(alpha: 0.15) : Colors.white;
    final border = selected ? accent : accent.withValues(alpha: 0.45);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 2),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.15),
                offset: const Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: accent),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.fredoka(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
