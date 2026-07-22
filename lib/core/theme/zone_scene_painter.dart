import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Unique cartoon illustration layer painted behind each zone screen.
class ZoneSceneBackground extends StatelessWidget {
  const ZoneSceneBackground({super.key, required this.zoneId});

  final String zoneId;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ZoneScenePainter(zoneId: zoneId),
        size: Size.infinite,
      ),
    );
  }
}

class _ZoneScenePainter extends CustomPainter {
  _ZoneScenePainter({required this.zoneId});

  final String zoneId;

  @override
  void paint(Canvas canvas, Size size) {
    switch (zoneId) {
      case 'jungle_grove':
        _paintJungle(canvas, size);
        return;
      case 'number_mountain':
        _paintMountains(canvas, size);
        return;
      case 'letter_lane':
        _paintLetterLane(canvas, size);
        return;
      case 'color_canyon':
        _paintRainbowCanyon(canvas, size);
        return;
      case 'dinosaurs':
        _paintVolcanoLand(canvas, size);
        return;
      case 'space_science':
        _paintSpace(canvas, size);
        return;
      case 'sports_body':
        _paintSportsField(canvas, size);
        return;
      case 'drawing_den':
        _paintArtStudio(canvas, size);
        return;
      case 'puzzle_palace':
        _paintPuzzleCastle(canvas, size);
        return;
      case 'world_village':
        _paintVillage(canvas, size);
        return;
      case 'household_daily':
        _paintHouse(canvas, size);
        return;
      case 'seasons_holidays':
        _paintSeasons(canvas, size);
        return;
      case 'tools_professions':
        _paintWorkshop(canvas, size);
        return;
      case 'opposites_ocean':
        _paintOcean(canvas, size);
        return;
      case 'music_meadow':
        _paintMusicMeadow(canvas, size);
        return;
      default:
        _paintDefault(canvas, size);
    }
  }

  void _paintJungle(Canvas canvas, Size size) {
    final ground = Paint()..color = const Color(0xFF81C784).withValues(alpha: 0.45);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 1.05),
        width: size.width * 1.4,
        height: size.height * 0.45,
      ),
      ground,
    );
    _tree(canvas, Offset(size.width * 0.12, size.height * 0.78), 54, const Color(0xFF2E7D32));
    _tree(canvas, Offset(size.width * 0.88, size.height * 0.72), 62, const Color(0xFF388E3C));
    _tree(canvas, Offset(size.width * 0.72, size.height * 0.82), 40, const Color(0xFF43A047));
    _sun(canvas, Offset(size.width * 0.82, size.height * 0.14), 28);
  }

  void _paintMountains(Canvas canvas, Size size) {
    final far = Paint()..color = const Color(0xFF9FA8DA).withValues(alpha: 0.55);
    final near = Paint()..color = const Color(0xFF5C6BC0).withValues(alpha: 0.45);
    final farPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.42)
      ..lineTo(size.width * 0.4, size.height * 0.68)
      ..lineTo(size.width * 0.62, size.height * 0.35)
      ..lineTo(size.width * 0.85, size.height * 0.62)
      ..lineTo(size.width, size.height * 0.48)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(farPath, far);
    final nearPath = Path()
      ..moveTo(0, size.height * 0.82)
      ..lineTo(size.width * 0.28, size.height * 0.55)
      ..lineTo(size.width * 0.5, size.height * 0.78)
      ..lineTo(size.width * 0.78, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(nearPath, near);
    _cloud(canvas, Offset(size.width * 0.2, size.height * 0.18), 40);
    _cloud(canvas, Offset(size.width * 0.7, size.height * 0.12), 32);
  }

  void _paintLetterLane(Canvas canvas, Size size) {
    final road = Paint()..color = const Color(0xFFCE93D8).withValues(alpha: 0.35);
    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.55, size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, road);
    _bubble(canvas, Offset(size.width * 0.15, size.height * 0.22), 22, const Color(0xFFAB47BC));
    _bubble(canvas, Offset(size.width * 0.85, size.height * 0.28), 18, const Color(0xFF26C6DA));
    _bubble(canvas, Offset(size.width * 0.7, size.height * 0.16), 14, const Color(0xFFFFCA28));
  }

  void _paintRainbowCanyon(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF5252),
      const Color(0xFFFFAB40),
      const Color(0xFFFFEE58),
      const Color(0xFF69F0AE),
      const Color(0xFF40C4FF),
      const Color(0xFFEA80FC),
    ];
    for (var i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i].withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.95),
          width: size.width * 0.95 - i * 18,
          height: size.height * 0.7 - i * 14,
        ),
        math.pi,
        math.pi,
        false,
        paint,
      );
    }
  }

  void _paintVolcanoLand(Canvas canvas, Size size) {
    final ground = Paint()..color = const Color(0xFFA1887F).withValues(alpha: 0.4);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.72, size.width, size.height * 0.28),
      ground,
    );
    final volcano = Path()
      ..moveTo(size.width * 0.55, size.height * 0.72)
      ..lineTo(size.width * 0.72, size.height * 0.38)
      ..lineTo(size.width * 0.8, size.height * 0.38)
      ..lineTo(size.width * 0.95, size.height * 0.72)
      ..close();
    canvas.drawPath(volcano, Paint()..color = const Color(0xFF5D4037).withValues(alpha: 0.55));
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.34),
      18,
      Paint()..color = const Color(0xFFFF8F00).withValues(alpha: 0.55),
    );
    _sun(canvas, Offset(size.width * 0.18, size.height * 0.16), 24);
  }

  void _paintSpace(Canvas canvas, Size size) {
    final rng = math.Random(42);
    for (var i = 0; i < 70; i++) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25 + rng.nextDouble() * 0.55);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height * 0.85),
        1 + rng.nextDouble() * 2.2,
        paint,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      28,
      Paint()..color = const Color(0xFFFFF59D).withValues(alpha: 0.55),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.28),
        width: 42,
        height: 28,
      ),
      Paint()..color = const Color(0xFF7E57C2).withValues(alpha: 0.45),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.28),
        width: 70,
        height: 14,
      ),
      Paint()
        ..color = const Color(0xFFB39DDB).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _paintSportsField(Canvas canvas, Size size) {
    final field = Paint()..color = const Color(0xFF81C784).withValues(alpha: 0.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.62, size.width * 0.84, size.height * 0.28),
        const Radius.circular(24),
      ),
      field,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.76),
      28,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.22),
      16,
      Paint()..color = const Color(0xFFE53935).withValues(alpha: 0.45),
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.28),
      14,
      Paint()..color = const Color(0xFF1E88E5).withValues(alpha: 0.4),
    );
  }

  void _paintArtStudio(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF5252),
      const Color(0xFF448AFF),
      const Color(0xFF69F0AE),
      const Color(0xFFFFD740),
      const Color(0xFFE040FB),
    ];
    for (var i = 0; i < colors.length; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.12 + i * 0.18), size.height * 0.12),
        10,
        Paint()..color = colors[i].withValues(alpha: 0.22),
      );
    }
    // Soft paint blobs only — no tall easel lines that cut through content.
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.78),
      28,
      Paint()..color = const Color(0xFF90CAF9).withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.82),
      22,
      Paint()..color = const Color(0xFFFFAB91).withValues(alpha: 0.16),
    );
  }

  void _paintPuzzleCastle(Canvas canvas, Size size) {
    // Soft corner accents only — avoid big purple walls behind the board.
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * (0.1 + i * 0.12),
            size.height * 0.88,
            22,
            22,
          ),
          const Radius.circular(6),
        ),
        Paint()
          ..color = [
            const Color(0xFFFF7043),
            const Color(0xFF26A69A),
            const Color(0xFFFFCA28),
            const Color(0xFF7E57C2),
          ][i]
              .withValues(alpha: 0.22),
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.14),
      18,
      Paint()..color = const Color(0xFFB39DDB).withValues(alpha: 0.2),
    );
  }

  void _paintVillage(Canvas canvas, Size size) {
    _houseShape(canvas, Offset(size.width * 0.18, size.height * 0.7), 70, const Color(0xFF26A69A));
    _houseShape(canvas, Offset(size.width * 0.72, size.height * 0.68), 80, const Color(0xFF00897B));
    _sun(canvas, Offset(size.width * 0.85, size.height * 0.15), 26);
    _cloud(canvas, Offset(size.width * 0.3, size.height * 0.18), 36);
  }

  void _paintHouse(Canvas canvas, Size size) {
    _houseShape(canvas, Offset(size.width * 0.55, size.height * 0.62), 110, const Color(0xFFA1887F));
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.22),
      20,
      Paint()..color = const Color(0xFFFFD54F).withValues(alpha: 0.5),
    );
  }

  void _paintSeasons(Canvas canvas, Size size) {
    _sun(canvas, Offset(size.width * 0.18, size.height * 0.16), 22);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.2),
      18,
      Paint()..color = const Color(0xFFE1F5FE).withValues(alpha: 0.7),
    );
    final leafPaint = Paint()..color = const Color(0xFFFF8A65).withValues(alpha: 0.45);
    for (var i = 0; i < 8; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * (0.2 + i * 0.09), size.height * (0.55 + (i % 3) * 0.08)),
          width: 16,
          height: 10,
        ),
        leafPaint,
      );
    }
    final ground = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.68, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xFF81D4FA).withValues(alpha: 0.35));
  }

  void _paintWorkshop(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.7, size.width * 0.8, size.height * 0.18),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFF90A4AE).withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.55),
      22,
      Paint()..color = const Color(0xFFFFB300).withValues(alpha: 0.4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.75, size.height * 0.5),
          width: 50,
          height: 18,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF546E7A).withValues(alpha: 0.4),
    );
  }

  void _paintOcean(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      Paint()..color = const Color(0xFF4FC3F7).withValues(alpha: 0.4),
    );
    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.66 + i * 0.07);
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += size.width / 5) {
        path.quadraticBezierTo(
          x + size.width / 10,
          y + (i.isEven ? -8 : 8),
          x + size.width / 5,
          y,
        );
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.18),
      24,
      Paint()..color = const Color(0xFFFFF59D).withValues(alpha: 0.55),
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.78),
      10,
      Paint()..color = Colors.white.withValues(alpha: 0.4),
    );
  }

  void _paintMusicMeadow(Canvas canvas, Size size) {
    final hill = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.58, size.width * 0.7, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.82, size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFFCE93D8).withValues(alpha: 0.4));
    final note = Paint()..color = const Color(0xFF8E24AA).withValues(alpha: 0.35);
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.15), size.height * (0.22 + (i % 2) * 0.08)),
        8,
        note,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * (0.2 + i * 0.15) + 6,
          size.height * (0.12 + (i % 2) * 0.08),
          4,
          28,
        ),
        note,
      );
    }
  }

  void _paintDefault(Canvas canvas, Size size) {
    _sun(canvas, Offset(size.width * 0.8, size.height * 0.15), 24);
    _cloud(canvas, Offset(size.width * 0.25, size.height * 0.2), 36);
  }

  void _sun(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFFFF176).withValues(alpha: 0.55));
    canvas.drawCircle(c, r * 0.65, Paint()..color = const Color(0xFFFFEE58).withValues(alpha: 0.7));
  }

  void _cloud(Canvas canvas, Offset c, double r) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.45);
    canvas.drawCircle(c, r * 0.55, p);
    canvas.drawCircle(c.translate(-r * 0.45, 4), r * 0.4, p);
    canvas.drawCircle(c.translate(r * 0.45, 4), r * 0.42, p);
  }

  void _tree(Canvas canvas, Offset base, double h, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: base, width: 10, height: h * 0.35),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF6D4C41).withValues(alpha: 0.5),
    );
    canvas.drawCircle(
      base.translate(0, -h * 0.35),
      h * 0.28,
      Paint()..color = color.withValues(alpha: 0.5),
    );
  }

  void _bubble(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c, r, Paint()..color = color.withValues(alpha: 0.35));
  }

  void _houseShape(Canvas canvas, Offset base, double w, Color color) {
    final h = w * 0.7;
    final body = Rect.fromCenter(center: base, width: w, height: h * 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(6)),
      Paint()..color = color.withValues(alpha: 0.4),
    );
    final roof = Path()
      ..moveTo(body.left - 6, body.top + 8)
      ..lineTo(body.center.dx, body.top - h * 0.35)
      ..lineTo(body.right + 6, body.top + 8)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFFE57373).withValues(alpha: 0.45));
  }

  @override
  bool shouldRepaint(covariant _ZoneScenePainter oldDelegate) =>
      oldDelegate.zoneId != zoneId;
}
