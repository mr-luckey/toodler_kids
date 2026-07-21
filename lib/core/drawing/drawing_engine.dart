import 'package:flutter/material.dart';
class DrawPoint {
  DrawPoint(this.offset, [this.pressure = 1.0]);
  final Offset offset;
  final double pressure;
}

class SmoothStroke {
  SmoothStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<DrawPoint> points;
  final Color color;
  final double strokeWidth;

  Path toPath() {
    final path = Path();
    if (points.isEmpty) return path;
    if (points.length == 1) {
      path.addOval(Rect.fromCircle(
        center: points.first.offset,
        radius: strokeWidth / 2,
      ));
      return path;
    }

    path.moveTo(points.first.offset.dx, points.first.offset.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i].offset;
      final p1 = points[i + 1].offset;
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.offset.dx, points.last.offset.dy);
    return path;
  }
}

class FreeDrawPainter extends CustomPainter {
  FreeDrawPainter({required this.strokes});

  final List<SmoothStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      canvas.drawPath(stroke.toPath(), paint);
    }
  }

  @override
  bool shouldRepaint(FreeDrawPainter oldDelegate) =>
      oldDelegate.strokes != strokes;
}

class FreeDrawCanvas extends StatefulWidget {
  const FreeDrawCanvas({
    super.key,
    required this.color,
    required this.strokeWidth,
    required this.strokes,
    required this.onStrokeComplete,
    this.enabled = true,
  });

  final Color color;
  final double strokeWidth;
  final List<SmoothStroke> strokes;
  final ValueChanged<SmoothStroke> onStrokeComplete;
  final bool enabled;

  @override
  State<FreeDrawCanvas> createState() => _FreeDrawCanvasState();
}

class _FreeDrawCanvasState extends State<FreeDrawCanvas> {
  List<DrawPoint>? _currentPoints;

  void _onPanStart(DragStartDetails details) {
    if (!widget.enabled) return;
    _currentPoints = [DrawPoint(details.localPosition)];
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enabled || _currentPoints == null) return;
    setState(() {
      _currentPoints!.add(DrawPoint(details.localPosition));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPoints == null || _currentPoints!.length < 2) {
      _currentPoints = null;
      return;
    }
    widget.onStrokeComplete(SmoothStroke(
      points: List.from(_currentPoints!),
      color: widget.color,
      strokeWidth: widget.strokeWidth,
    ));
    _currentPoints = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allStrokes = [
      ...widget.strokes,
      if (_currentPoints != null && _currentPoints!.length > 1)
        SmoothStroke(
          points: _currentPoints!,
          color: widget.color,
          strokeWidth: widget.strokeWidth,
        ),
    ];

    return RepaintBoundary(
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: FreeDrawPainter(strokes: allStrokes),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class ColorFillRegion {
  ColorFillRegion({
    required this.id,
    required this.pathData,
    required this.defaultColor,
  });

  final String id;
  final String pathData;
  final Color defaultColor;

  Path parsePath(Size size) {
    // Simple rect/circle path parsing for SVG regions
    if (pathData.startsWith('rect:')) {
      final parts = pathData.substring(5).split(',');
      final rect = Rect.fromLTWH(
        double.parse(parts[0]) * size.width,
        double.parse(parts[1]) * size.height,
        double.parse(parts[2]) * size.width,
        double.parse(parts[3]) * size.height,
      );
      return Path()..addRect(rect);
    }
    if (pathData.startsWith('circle:')) {
      final parts = pathData.substring(7).split(',');
      final center = Offset(
        double.parse(parts[0]) * size.width,
        double.parse(parts[1]) * size.height,
      );
      final radius = double.parse(parts[2]) * size.width;
      return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    }
    return Path();
  }
}

class ColorFillCanvas extends StatefulWidget {
  const ColorFillCanvas({
    super.key,
    required this.regions,
    required this.regionColors,
    required this.selectedColor,
    required this.onRegionFilled,
    this.backgroundColor = Colors.white,
  });

  final List<ColorFillRegion> regions;
  final Map<String, Color> regionColors;
  final Color selectedColor;
  final void Function(String regionId, Color color) onRegionFilled;
  final Color backgroundColor;

  @override
  State<ColorFillCanvas> createState() => _ColorFillCanvasState();
}

class _ColorFillCanvasState extends State<ColorFillCanvas> {
  String? _lastFilledId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapUp: (details) {
            for (final region in widget.regions) {
              final path = region.parsePath(size);
              if (path.contains(details.localPosition)) {
                setState(() => _lastFilledId = region.id);
                widget.onRegionFilled(region.id, widget.selectedColor);
                break;
              }
            }
          },
          child: CustomPaint(
            size: size,
            painter: _ColorFillPainter(
              regions: widget.regions,
              regionColors: widget.regionColors,
              backgroundColor: widget.backgroundColor,
              highlightId: _lastFilledId,
            ),
          ),
        );
      },
    );
  }
}

class _ColorFillPainter extends CustomPainter {
  _ColorFillPainter({
    required this.regions,
    required this.regionColors,
    required this.backgroundColor,
    this.highlightId,
  });

  final List<ColorFillRegion> regions;
  final Map<String, Color> regionColors;
  final Color backgroundColor;
  final String? highlightId;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    for (final region in regions) {
      final path = region.parsePath(size);
      final color = regionColors[region.id] ?? region.defaultColor;
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(path, fillPaint);

      final strokePaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..isAntiAlias = true;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_ColorFillPainter oldDelegate) =>
      oldDelegate.regionColors != regionColors ||
      oldDelegate.highlightId != highlightId;
}

class TraceCanvas extends StatefulWidget {
  const TraceCanvas({
    super.key,
    required this.templatePath,
    required this.onTraceProgress,
    this.strokeColor = const Color(0xFF6C63FF),
  });

  final String templatePath;
  final ValueChanged<double> onTraceProgress;
  final Color strokeColor;

  @override
  State<TraceCanvas> createState() => _TraceCanvasState();
}

class _TraceCanvasState extends State<TraceCanvas> {
  final List<Offset> _tracePoints = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() => _tracePoints.add(details.localPosition));
        widget.onTraceProgress(
          (_tracePoints.length / 100).clamp(0.0, 1.0),
        );
      },
      child: CustomPaint(
        painter: _TracePainter(
          tracePoints: _tracePoints,
          strokeColor: widget.strokeColor,
        ),
        child: Container(),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  _TracePainter({required this.tracePoints, required this.strokeColor});

  final List<Offset> tracePoints;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (tracePoints.length < 2) return;
    final stroke = SmoothStroke(
      points: tracePoints.map((o) => DrawPoint(o)).toList(),
      color: strokeColor,
      strokeWidth: 8,
    );
    canvas.drawPath(
      stroke.toPath(),
      Paint()
        ..color = strokeColor
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_TracePainter oldDelegate) =>
      oldDelegate.tracePoints != tracePoints;
}
