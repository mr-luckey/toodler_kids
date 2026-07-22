import 'package:flutter/material.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';

/// Builds accurate hit-test paths from coloring-book SVG markup.
class SvgRegionParser {
  SvgRegionParser._();

  static const _viewBox = 200.0;

  static List<ColorFillRegion> regionsFromSvg(String svg, List<String> ids) {
    return ids
        .map(
          (id) => ColorFillRegion(
            id: id,
            pathData: _hitPathForId(svg, id),
            defaultColor: const Color(0xFFFFFFFF),
          ),
        )
        .toList();
  }

  static String _hitPathForId(String svg, String id) {
    final tagRe = RegExp('<(\\w+)[^>]*\\bid="$id"[^>]*>', dotAll: true);
    final match = tagRe.firstMatch(svg);
    if (match == null) return 'rect:0.4,0.4,0.2,0.2';

    final tag = match.group(0)!;
    final tagName = match.group(1)!;
    final transform = _attrStr(tag, 'transform');

    switch (tagName) {
      case 'circle':
        final cx = _attr(tag, 'cx') ?? 100;
        final cy = _attr(tag, 'cy') ?? 100;
        final r = _attr(tag, 'r') ?? 10;
        return _maybeTransform(
          transform,
          'circle:${cx / _viewBox},${cy / _viewBox},${r / _viewBox}',
        );
      case 'ellipse':
        final cx = _attr(tag, 'cx') ?? 100;
        final cy = _attr(tag, 'cy') ?? 100;
        final rx = _attr(tag, 'rx') ?? 10;
        final ry = _attr(tag, 'ry') ?? 10;
        return _maybeTransform(
          transform,
          'ellipse:${cx / _viewBox},${cy / _viewBox},'
              '${rx / _viewBox},${ry / _viewBox}',
        );
      case 'path':
        final d = _attrStr(tag, 'd');
        if (d == null || d.isEmpty) return 'rect:0.35,0.35,0.3,0.3';
        return _maybeTransform(transform, 'pathd:$d');
      case 'polygon':
        final points = _attrStr(tag, 'points');
        if (points == null) return 'rect:0.4,0.4,0.2,0.2';
        final coords = points
            .split(RegExp(r'[\s,]+'))
            .where((s) => s.isNotEmpty)
            .map(double.parse)
            .toList();
        if (coords.length < 4) return 'rect:0.4,0.4,0.2,0.2';
        final normalized =
            coords.map((v) => v / _viewBox).join(',');
        return _maybeTransform(transform, 'poly:$normalized');
      case 'rect':
        final x = _attr(tag, 'x') ?? 0;
        final y = _attr(tag, 'y') ?? 0;
        final w = _attr(tag, 'width') ?? 20;
        final h = _attr(tag, 'height') ?? 20;
        return _maybeTransform(
          transform,
          'rect:${x / _viewBox},${y / _viewBox},${w / _viewBox},${h / _viewBox}',
        );
      default:
        return 'rect:0.35,0.35,0.3,0.3';
    }
  }

  static String _maybeTransform(String? transform, String path) {
    if (transform == null || transform.isEmpty) return path;
    final rotate = RegExp(r'rotate\(([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\)')
        .firstMatch(transform);
    if (rotate != null) {
      final angle = rotate.group(1);
      final cx = (double.parse(rotate.group(2)!) / _viewBox);
      final cy = (double.parse(rotate.group(3)!) / _viewBox);
      return '$path@rotate:$angle,$cx,$cy';
    }
    return path;
  }

  static double? _attr(String tag, String name) {
    final m = RegExp('(?:^|\\s)$name="([\\d.]+)"').firstMatch(tag);
    return m != null ? double.tryParse(m.group(1)!) : null;
  }

  static String? _attrStr(String tag, String name) {
    final m = RegExp('$name="([^"]*)"').firstMatch(tag);
    return m?.group(1);
  }
}
