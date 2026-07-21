import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';

/// Rich per-zone visual identity (colors, gradients, decorations).
class ZoneVisualTheme {
  const ZoneVisualTheme({
    required this.id,
    required this.primary,
    required this.accent,
    required this.background,
    required this.hubGradient,
    required this.screenGradient,
    this.isDark = false,
    this.decorations = const [],
    this.cardBorderColor,
  });

  final String id;
  final Color primary;
  final Color accent;
  final Color background;
  final List<Color> hubGradient;
  final List<Color> screenGradient;
  final bool isDark;
  final List<ZoneDecoration> decorations;
  final Color? cardBorderColor;

  LinearGradient get hub => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: hubGradient,
      );

  LinearGradient get screen => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: screenGradient,
      );

  Color get textOnBackground => isDark ? Colors.white : AppTheme.textDark;
  Color get appBarForeground => isDark ? Colors.white : AppTheme.textDark;

  static ZoneVisualTheme forZone(String zoneId) {
    switch (zoneId) {
      case 'jungle_grove':
        return const ZoneVisualTheme(
          id: 'jungle_grove',
          primary: Color(0xFF43A047),
          accent: Color(0xFFFF9800),
          background: Color(0xFFE8F5E9),
          hubGradient: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
          screenGradient: [Color(0xFFC8E6C9), Color(0xFFE8F5E9), Color(0xFFFFF8E1)],
          decorations: [ZoneDecoration.leaves],
          cardBorderColor: Color(0xFF2E7D32),
        );
      case 'number_mountain':
        return const ZoneVisualTheme(
          id: 'number_mountain',
          primary: Color(0xFF5C6BC0),
          accent: Color(0xFFFF7043),
          background: Color(0xFFE8EAF6),
          hubGradient: [Color(0xFF7986CB), Color(0xFF3949AB)],
          screenGradient: [Color(0xFFC5CAE9), Color(0xFFE8EAF6), Color(0xFFFFF3E0)],
          decorations: [ZoneDecoration.clouds],
          cardBorderColor: Color(0xFF3949AB),
        );
      case 'letter_lane':
        return const ZoneVisualTheme(
          id: 'letter_lane',
          primary: Color(0xFFAB47BC),
          accent: Color(0xFF26C6DA),
          background: Color(0xFFF3E5F5),
          hubGradient: [Color(0xFFCE93D8), Color(0xFF8E24AA)],
          screenGradient: [Color(0xFFE1BEE7), Color(0xFFF3E5F5), Color(0xFFE0F7FA)],
          decorations: [ZoneDecoration.sparkles],
          cardBorderColor: Color(0xFF8E24AA),
        );
      case 'color_canyon':
        return const ZoneVisualTheme(
          id: 'color_canyon',
          primary: Color(0xFFEC407A),
          accent: Color(0xFFFFCA28),
          background: Color(0xFFFCE4EC),
          hubGradient: [Color(0xFFF06292), Color(0xFFE91E63)],
          screenGradient: [Color(0xFFF8BBD9), Color(0xFFFFF9C4), Color(0xFFFCE4EC)],
          decorations: [ZoneDecoration.rainbow],
          cardBorderColor: Color(0xFFE91E63),
        );
      case 'dinosaurs':
        return const ZoneVisualTheme(
          id: 'dinosaurs',
          primary: Color(0xFF6D4C41),
          accent: Color(0xFFFF8F00),
          background: Color(0xFFEFEBE9),
          hubGradient: [Color(0xFF8D6E63), Color(0xFF4E342E)],
          screenGradient: [Color(0xFFD7CCC8), Color(0xFFEFEBE9), Color(0xFFFFE0B2)],
          decorations: [ZoneDecoration.volcano],
          cardBorderColor: Color(0xFF4E342E),
        );
      case 'space_science':
        return const ZoneVisualTheme(
          id: 'space_science',
          primary: Color(0xFF5C6BC0),
          accent: Color(0xFF7E57C2),
          background: Color(0xFF1A237E),
          hubGradient: [Color(0xFF283593), Color(0xFF0D1B5E)],
          screenGradient: [Color(0xFF1A237E), Color(0xFF311B92), Color(0xFF0D1B5E)],
          isDark: true,
          decorations: [ZoneDecoration.stars],
          cardBorderColor: Color(0xFF7E57C2),
        );
      case 'sports_body':
        return const ZoneVisualTheme(
          id: 'sports_body',
          primary: Color(0xFFE53935),
          accent: Color(0xFF1E88E5),
          background: Color(0xFFFFEBEE),
          hubGradient: [Color(0xFFEF5350), Color(0xFFC62828)],
          screenGradient: [Color(0xFFFFCDD2), Color(0xFFE3F2FD), Color(0xFFFFEBEE)],
          decorations: [ZoneDecoration.balls],
          cardBorderColor: Color(0xFFC62828),
        );
      case 'drawing_den':
        return const ZoneVisualTheme(
          id: 'drawing_den',
          primary: Color(0xFF42A5F5),
          accent: Color(0xFFFF7043),
          background: Color(0xFFE3F2FD),
          hubGradient: [Color(0xFF64B5F6), Color(0xFF1565C0)],
          screenGradient: [Color(0xFFBBDEFB), Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
          decorations: [ZoneDecoration.paint],
          cardBorderColor: Color(0xFF1565C0),
        );
      case 'puzzle_palace':
        return const ZoneVisualTheme(
          id: 'puzzle_palace',
          primary: Color(0xFF7E57C2),
          accent: Color(0xFFFF7043),
          background: Color(0xFFEDE7F6),
          hubGradient: [Color(0xFF9575CD), Color(0xFF512DA8)],
          screenGradient: [Color(0xFFD1C4E9), Color(0xFFEDE7F6), Color(0xFFFFF8E1)],
          decorations: [ZoneDecoration.sparkles],
          cardBorderColor: Color(0xFF512DA8),
        );
      case 'world_village':
        return const ZoneVisualTheme(
          id: 'world_village',
          primary: Color(0xFF00897B),
          accent: Color(0xFFFFB300),
          background: Color(0xFFE0F2F1),
          hubGradient: [Color(0xFF26A69A), Color(0xFF00695C)],
          screenGradient: [Color(0xFFB2DFDB), Color(0xFFE0F2F1), Color(0xFFFFF9C4)],
          decorations: [ZoneDecoration.clouds],
          cardBorderColor: Color(0xFF00695C),
        );
      case 'household_daily':
        return const ZoneVisualTheme(
          id: 'household_daily',
          primary: Color(0xFF8D6E63),
          accent: Color(0xFF66BB6A),
          background: Color(0xFFEFEBE9),
          hubGradient: [Color(0xFFA1887F), Color(0xFF5D4037)],
          screenGradient: [Color(0xFFD7CCC8), Color(0xFFEFEBE9), Color(0xFFE8F5E9)],
          decorations: [ZoneDecoration.clouds],
          cardBorderColor: Color(0xFF5D4037),
        );
      case 'seasons_holidays':
        return const ZoneVisualTheme(
          id: 'seasons_holidays',
          primary: Color(0xFF039BE5),
          accent: Color(0xFFFF7043),
          background: Color(0xFFE1F5FE),
          hubGradient: [Color(0xFF29B6F6), Color(0xFF0277BD)],
          screenGradient: [Color(0xFFB3E5FC), Color(0xFFFFE0B2), Color(0xFFE1F5FE)],
          decorations: [ZoneDecoration.rainbow],
          cardBorderColor: Color(0xFF0277BD),
        );
      case 'tools_professions':
        return const ZoneVisualTheme(
          id: 'tools_professions',
          primary: Color(0xFF546E7A),
          accent: Color(0xFFFFB300),
          background: Color(0xFFECEFF1),
          hubGradient: [Color(0xFF78909C), Color(0xFF37474F)],
          screenGradient: [Color(0xFFCFD8DC), Color(0xFFECEFF1), Color(0xFFFFF8E1)],
          decorations: [ZoneDecoration.balls],
          cardBorderColor: Color(0xFF37474F),
        );
      case 'opposites_ocean':
        return const ZoneVisualTheme(
          id: 'opposites_ocean',
          primary: Color(0xFF0288D1),
          accent: Color(0xFFEC407A),
          background: Color(0xFFE1F5FE),
          hubGradient: [Color(0xFF039BE5), Color(0xFF01579B)],
          screenGradient: [Color(0xFF81D4FA), Color(0xFFE1F5FE), Color(0xFFFCE4EC)],
          decorations: [ZoneDecoration.clouds],
          cardBorderColor: Color(0xFF01579B),
        );
      case 'music_meadow':
        return const ZoneVisualTheme(
          id: 'music_meadow',
          primary: Color(0xFF8E24AA),
          accent: Color(0xFF26C6DA),
          background: Color(0xFFF3E5F5),
          hubGradient: [Color(0xFFAB47BC), Color(0xFF6A1B9A)],
          screenGradient: [Color(0xFFE1BEE7), Color(0xFFF3E5F5), Color(0xFFE0F7FA)],
          decorations: [ZoneDecoration.sparkles],
          cardBorderColor: Color(0xFF6A1B9A),
        );
      default:
        return const ZoneVisualTheme(
          id: 'default',
          primary: Color(0xFF6C63FF),
          accent: Color(0xFFFFB74D),
          background: Color(0xFFF0F4FF),
          hubGradient: [Color(0xFF6C63FF), Color(0xFF4E47C6)],
          screenGradient: [Color(0xFFE8EAFF), Color(0xFFFFF8F0), Color(0xFFF0F4FF)],
          decorations: [ZoneDecoration.sparkles],
          cardBorderColor: Color(0xFF4E47C6),
        );
    }
  }

  static ZoneVisualTheme fromPalette(String zoneId) {
    final palette = ZonePalette.forZone(zoneId);
    final base = forZone(zoneId);
    return ZoneVisualTheme(
      id: zoneId,
      primary: palette.primary,
      accent: palette.accent,
      background: palette.background,
      hubGradient: base.hubGradient,
      screenGradient: base.screenGradient,
      isDark: base.isDark,
      decorations: base.decorations,
      cardBorderColor: base.cardBorderColor,
    );
  }
}

enum ZoneDecoration { leaves, clouds, sparkles, rainbow, volcano, stars, balls, paint }

/// Themed background layer for game/zone screens.
class ZoneThemedBackground extends StatelessWidget {
  const ZoneThemedBackground({
    super.key,
    required this.theme,
    required this.child,
  });

  final ZoneVisualTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(gradient: theme.screen),
        ),
        ...theme.decorations.map((d) => _DecorationLayer(type: d, isDark: theme.isDark)),
        child,
      ],
    );
  }
}

class _DecorationLayer extends StatelessWidget {
  const _DecorationLayer({required this.type, required this.isDark});

  final ZoneDecoration type;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ZoneDecoration.stars => const _Starfield(),
      ZoneDecoration.leaves => _FloatingEmojis(emojis: ['🍃', '🌿', '🌳'], count: 8),
      ZoneDecoration.clouds => _FloatingEmojis(emojis: ['☁️', '⛅'], count: 6),
      ZoneDecoration.sparkles => _FloatingEmojis(emojis: ['✨', '⭐', '💫'], count: 10),
      ZoneDecoration.rainbow => _FloatingEmojis(emojis: ['🌈', '🎨', '🖍️'], count: 6),
      ZoneDecoration.volcano => _FloatingEmojis(emojis: ['🌋', '🦕', '🦴'], count: 6),
      ZoneDecoration.balls => _FloatingEmojis(emojis: ['⚽', '🏀', '🎾'], count: 6),
      ZoneDecoration.paint => _FloatingEmojis(emojis: ['🎨', '🖌️', '✏️'], count: 6),
    };
  }
}

class _Starfield extends StatelessWidget {
  const _Starfield();

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(7);
    return IgnorePointer(
      child: CustomPaint(
        painter: _StarPainter(
          stars: List.generate(60, (_) => _Star(
                x: rng.nextDouble(),
                y: rng.nextDouble(),
                size: rng.nextDouble() * 2.5 + 1,
                opacity: rng.nextDouble() * 0.6 + 0.2,
              )),
        ),
      ),
    );
  }
}

class _Star {
  _Star({required this.x, required this.y, required this.size, required this.opacity});
  final double x, y, size, opacity;
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.stars});
  final List<_Star> stars;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final paint = Paint()..color = Colors.white.withValues(alpha: s.opacity);
      canvas.drawCircle(Offset(s.x * size.width, s.y * size.height), s.size, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FloatingEmojis extends StatelessWidget {
  const _FloatingEmojis({required this.emojis, required this.count});

  final List<String> emojis;
  final int count;

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(emojis.length);
    return IgnorePointer(
      child: Stack(
        children: List.generate(count, (i) {
          final emoji = emojis[i % emojis.length];
          return Positioned(
            left: (rng.nextDouble() * 0.85 + 0.05) * MediaQuery.sizeOf(context).width,
            top: (rng.nextDouble() * 0.7 + 0.05) * MediaQuery.sizeOf(context).height,
            child: Opacity(
              opacity: 0.12 + rng.nextDouble() * 0.15,
              child: Text(emoji, style: TextStyle(fontSize: 20 + rng.nextDouble() * 24)),
            ),
          );
        }),
      ),
    );
  }
}
