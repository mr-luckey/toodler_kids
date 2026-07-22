import 'package:flutter/material.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';

class DrawingProgressCodec {
  DrawingProgressCodec._();

  static Map<String, dynamic> encode({
    required String mode,
    required Color selectedColor,
    required List<SmoothStroke> colorStrokes,
    required List<SmoothStroke> strokes,
    Map<String, Color> regionColors = const {},
  }) {
    return {
      'version': 2,
      'mode': mode,
      'selectedColor': selectedColor.toARGB32(),
      'colorStrokes': colorStrokes.map(_encodeStroke).toList(),
      'strokes': strokes.map(_encodeStroke).toList(),
      'regionColors': regionColors.map(
        (k, v) => MapEntry(k, v.toARGB32()),
      ),
      'savedAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> _encodeStroke(SmoothStroke stroke) => {
        'color': stroke.color.toARGB32(),
        'strokeWidth': stroke.strokeWidth,
        'points': stroke.points
            .map(
              (p) => {'dx': p.offset.dx, 'dy': p.offset.dy},
            )
            .toList(),
      };

  static List<SmoothStroke> decodeStrokes(Object? raw) {
    if (raw is! List) return [];
    final strokes = <SmoothStroke>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final colorValue = item['color'];
      final width = item['strokeWidth'];
      final pointsRaw = item['points'];
      if (colorValue is! int || width is! num || pointsRaw is! List) continue;
      final points = <DrawPoint>[];
      for (final point in pointsRaw) {
        if (point is! Map) continue;
        final dx = point['dx'];
        final dy = point['dy'];
        if (dx is num && dy is num) {
          points.add(DrawPoint(Offset(dx.toDouble(), dy.toDouble())));
        }
      }
      if (points.isEmpty) continue;
      strokes.add(
        SmoothStroke(
          points: points,
          color: Color(colorValue),
          strokeWidth: width.toDouble(),
        ),
      );
    }
    return strokes;
  }

  static String? decodeModeName(Object? raw) {
    if (raw is String && raw.isNotEmpty) return raw;
    return null;
  }

  static Color? decodeColor(Object? raw) {
    if (raw is int) return Color(raw);
    if (raw is String) return Color(int.tryParse(raw) ?? 0xFFFF5252);
    return null;
  }

  static Map<String, Color> decodeRegionColors(Object? raw) {
    if (raw is! Map) return {};
    final colors = <String, Color>{};
    raw.forEach((key, value) {
      final color = decodeColor(value);
      if (color != null) colors[key.toString()] = color;
    });
    return colors;
  }
}
