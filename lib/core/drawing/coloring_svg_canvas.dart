import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';
import 'package:toodler_kids/core/drawing/svg_layout.dart';
import 'package:toodler_kids/core/drawing/svg_region_parser.dart';

/// Drag-to-color canvas that renders SVG outlines with per-region fills.
class ColoringSvgCanvas extends StatefulWidget {
  const ColoringSvgCanvas({
    super.key,
    required this.svgAssetPath,
    required this.regions,
    required this.regionColors,
    required this.selectedColor,
    required this.onRegionFilled,
    this.onMiss,
  });

  final String svgAssetPath;
  final List<ColorFillRegion> regions;
  final Map<String, Color> regionColors;
  final Color selectedColor;
  final void Function(String regionId, Color color) onRegionFilled;
  final VoidCallback? onMiss;

  @override
  State<ColoringSvgCanvas> createState() => _ColoringSvgCanvasState();
}

class _ColoringSvgCanvasState extends State<ColoringSvgCanvas>
    with SingleTickerProviderStateMixin {
  String? _svgRaw;
  List<ColorFillRegion> _hitRegions = [];
  late AnimationController _missController;
  int _missPulse = 0;
  final Set<String> _strokeFilled = {};
  bool _hadHitThisStroke = false;

  @override
  void initState() {
    super.initState();
    _missController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _loadSvg();
  }

  @override
  void dispose() {
    _missController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ColoringSvgCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgAssetPath != widget.svgAssetPath) {
      _loadSvg();
    }
  }

  Future<void> _loadSvg() async {
    final raw = await rootBundle.loadString(widget.svgAssetPath);
    if (!mounted) return;
    final ids = widget.regions.map((r) => r.id).toList();
    setState(() {
      _svgRaw = raw;
      _hitRegions = SvgRegionParser.regionsFromSvg(raw, ids);
    });
  }

  String _colorize(String svg) {
    var result = svg;
    for (final region in widget.regions) {
      final color = widget.regionColors[region.id];
      if (color == null) continue;
      final hex =
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      final escaped = RegExp.escape(region.id);
      result = result.replaceAllMapped(
        RegExp(
          '(<[^>]*\\bid="$escaped"[^>]*\\bfill=")#(?:FFF|FFFFFF|fff|ffffff)(")',
          caseSensitive: false,
        ),
        (m) => '${m.group(1)}$hex${m.group(2)}',
      );
    }
    return result;
  }

  List<ColorFillRegion> get _activeRegions =>
      _hitRegions.isNotEmpty ? _hitRegions : widget.regions;

  void _fillAt(Offset local, Size containerSize, {required bool fromDrag}) {
    final norm = SvgLayout.normalizedLocal(local, containerSize);
    if (norm == null) {
      if (!fromDrag) _triggerMiss();
      return;
    }

    for (final region in _activeRegions.reversed) {
      if (region.containsNormalized(norm)) {
        if (fromDrag && _strokeFilled.contains(region.id)) return;
        if (fromDrag) _strokeFilled.add(region.id);
        _hadHitThisStroke = true;
        widget.onRegionFilled(region.id, widget.selectedColor);
        return;
      }
    }

    if (!fromDrag) _triggerMiss();
  }

  void _onPanStart(DragStartDetails details, Size size) {
    _strokeFilled.clear();
    _hadHitThisStroke = false;
    _fillAt(details.localPosition, size, fromDrag: true);
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    _fillAt(details.localPosition, size, fromDrag: true);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_hadHitThisStroke) _triggerMiss();
    _strokeFilled.clear();
    _hadHitThisStroke = false;
  }

  void _triggerMiss() {
    setState(() => _missPulse++);
    _missController.forward(from: 0);
    widget.onMiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_svgRaw == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final colored = _colorize(_svgRaw!);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return AnimatedBuilder(
          animation: _missController,
          builder: (context, child) {
            final shake = _missController.isAnimating
                ? (2 * (_missController.value - 0.5).abs()) * 4
                : 0.0;
            return Transform.translate(
              offset: Offset(shake * (_missPulse.isEven ? 1 : -1), 0),
              child: child,
            );
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) => _onPanStart(details, size),
            onPanUpdate: (details) => _onPanUpdate(details, size),
            onPanEnd: _onPanEnd,
            onTapUp: (details) {
              _strokeFilled.clear();
              _hadHitThisStroke = false;
              _fillAt(details.localPosition, size, fromDrag: false);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.string(colored, fit: BoxFit.contain),
                if (_missPulse > 0 && _missController.isAnimating)
                  Positioned(
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: const Text(
                        'Drag inside the picture! 👆',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
