import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Accurate hit testing for normalized (0–1) coloring regions.
class RegionHitTester {
  RegionHitTester._();

  static const viewBoxSize = 200.0;
  static const defaultTolerance = 0.025;

  static bool contains(
    String pathData,
    Offset normalizedPoint, {
    double tolerance = defaultTolerance,
  }) {
    final transform = _splitTransform(pathData);
    final point = _inverseTransformPoint(normalizedPoint, transform);
    return _containsCore(transform.path, point, tolerance);
  }

  static ({String path, String? transform}) _splitTransform(String pathData) {
    final at = pathData.indexOf('@rotate:');
    if (at < 0) return (path: pathData, transform: null);
    return (
      path: pathData.substring(0, at),
      transform: pathData.substring(at + 8),
    );
  }

  static Offset _inverseTransformPoint(Offset point, ({String path, String? transform}) data) {
    final t = data.transform;
    if (t == null) return point;
    final parts = t.split(',');
    if (parts.length < 3) return point;
    final angle = -double.parse(parts[0]) * math.pi / 180;
    final cx = double.parse(parts[1]);
    final cy = double.parse(parts[2]);
    final dx = point.dx - cx;
    final dy = point.dy - cy;
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    return Offset(
      cx + dx * cosA - dy * sinA,
      cy + dx * sinA + dy * cosA,
    );
  }

  static bool _containsCore(String pathData, Offset normalizedPoint, double tolerance) {    if (pathData.startsWith('rect:')) {
      final parts = pathData.substring(5).split(',');
      if (parts.length < 4) return false;
      final rect = Rect.fromLTWH(
        double.parse(parts[0]) - tolerance,
        double.parse(parts[1]) - tolerance,
        double.parse(parts[2]) + tolerance * 2,
        double.parse(parts[3]) + tolerance * 2,
      );
      return rect.contains(normalizedPoint);
    }

    if (pathData.startsWith('circle:')) {
      final parts = pathData.substring(7).split(',');
      if (parts.length < 3) return false;
      final cx = double.parse(parts[0]);
      final cy = double.parse(parts[1]);
      final r = double.parse(parts[2]) + tolerance;
      final dx = normalizedPoint.dx - cx;
      final dy = normalizedPoint.dy - cy;
      return dx * dx + dy * dy <= r * r;
    }

    if (pathData.startsWith('ellipse:')) {
      final parts = pathData.substring(8).split(',');
      if (parts.length < 4) return false;
      final cx = double.parse(parts[0]);
      final cy = double.parse(parts[1]);
      final rx = double.parse(parts[2]) + tolerance;
      final ry = double.parse(parts[3]) + tolerance;
      if (rx <= 0 || ry <= 0) return false;
      final dx = (normalizedPoint.dx - cx) / rx;
      final dy = (normalizedPoint.dy - cy) / ry;
      return dx * dx + dy * dy <= 1;
    }

    if (pathData.startsWith('poly:')) {
      final parts = pathData.substring(5).split(',');
      if (parts.length < 6) return false;
      final path = Path();
      for (var i = 0; i < parts.length - 1; i += 2) {
        final x = double.parse(parts[i]);
        final y = double.parse(parts[i + 1]);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      return path.contains(normalizedPoint);
    }

    if (pathData.startsWith('pathd:')) {
      try {
        final d = pathData.substring(6);
        final path = parseSvgPathData(d);
        final scaled = Offset(
          normalizedPoint.dx * viewBoxSize,
          normalizedPoint.dy * viewBoxSize,
        );
        return path.contains(scaled);
      } catch (_) {
        return false;
      }
    }

    return false;
  }
}