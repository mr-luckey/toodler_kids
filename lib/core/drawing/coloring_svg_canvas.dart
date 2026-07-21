import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';

/// Tap-to-fill coloring canvas that renders SVG outlines with per-region fills.
class ColoringSvgCanvas extends StatefulWidget {
  const ColoringSvgCanvas({
    super.key,
    required this.svgAssetPath,
    required this.regions,
    required this.regionColors,
    required this.selectedColor,
    required this.onRegionFilled,
  });

  final String svgAssetPath;
  final List<ColorFillRegion> regions;
  final Map<String, Color> regionColors;
  final Color selectedColor;
  final void Function(String regionId, Color color) onRegionFilled;

  @override
  State<ColoringSvgCanvas> createState() => _ColoringSvgCanvasState();
}

class _ColoringSvgCanvasState extends State<ColoringSvgCanvas> {
  String? _svgRaw;

  @override
  void initState() {
    super.initState();
    _loadSvg();
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
    if (mounted) setState(() => _svgRaw = raw);
  }

  String _colorize(String svg) {
    var result = svg;
    for (final region in widget.regions) {
      final color = widget.regionColors[region.id];
      if (color == null || color == Colors.white) continue;
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

  @override
  Widget build(BuildContext context) {
    if (_svgRaw == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final colored = _colorize(_svgRaw!);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            for (final region in widget.regions.reversed) {
              final path = region.parsePath(size);
              if (path.contains(details.localPosition)) {
                widget.onRegionFilled(region.id, widget.selectedColor);
                break;
              }
            }
          },
          child: SvgPicture.string(
            colored,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
