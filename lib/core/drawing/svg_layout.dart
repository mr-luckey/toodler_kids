import 'package:flutter/material.dart';

/// Maps touch coordinates through [BoxFit.contain] letterboxing for SVG canvases.
class SvgLayout {
  SvgLayout._();

  static const Size viewBoxSize = Size(200, 200);

  static Rect fittedRect(Size containerSize) {
    final fitted = applyBoxFit(BoxFit.contain, viewBoxSize, containerSize);
    return Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & containerSize,
    );
  }

  /// Returns 0–1 normalized coords inside the fitted SVG rect, or null if outside.
  static Offset? normalizedLocal(Offset local, Size containerSize) {
    final rect = fittedRect(containerSize);
    if (!rect.contains(local)) return null;
    return Offset(
      (local.dx - rect.left) / rect.width,
      (local.dy - rect.top) / rect.height,
    );
  }
}
