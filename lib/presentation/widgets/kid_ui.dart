import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';

/// Scrollable game area — prevents overflow on all engines.
class KidGameShell extends StatelessWidget {
  const KidGameShell({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? EdgeInsets.all(Responsive.pad(context));
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: pad,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - pad.vertical,
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

/// Centered screen with safe area + optional scroll.
class KidScreenBody extends StatelessWidget {
  const KidScreenBody({
    super.key,
    required this.child,
    this.scroll = true,
    this.padding,
  });

  final Widget child;
  final bool scroll;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? EdgeInsets.all(Responsive.pad(context));
    final content = Padding(padding: pad, child: child);
    return SafeArea(
      child: scroll
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: content,
            )
          : content,
    );
  }
}

/// Colorful zone card — sticker / candy cartoon style with bounce press.
class KidZoneCard extends StatefulWidget {
  const KidZoneCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.primary,
    required this.accent,
    required this.onTap,
    this.locked = false,
    this.subtitle,
    this.zoneId,
    this.showLottieSticker = true,
  });

  final String emoji;
  final String title;
  final Color primary;
  final Color accent;
  final VoidCallback? onTap;
  final bool locked;
  final String? subtitle;
  final String? zoneId;
  final bool showLottieSticker;

  @override
  State<KidZoneCard> createState() => _KidZoneCardState();
}

class _KidZoneCardState extends State<KidZoneCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = Responsive.cardRadius(context) + 4;
    final lift = _pressed ? 2.0 : 8.0;
    final top = widget.locked ? Colors.grey.shade400 : widget.primary;
    final bottom = widget.locked
        ? Colors.grey.shade500
        : Color.lerp(widget.primary, widget.accent, 0.65)!;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        transform: Matrix4.translationValues(0, _pressed ? 6 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [top, bottom],
          ),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: bottom.withValues(alpha: 0.55),
              offset: Offset(0, lift),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: Offset(0, lift + 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Soft shine
            Positioned(
              top: 8,
              left: 10,
              right: 24,
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Mini illustrated scene peek at bottom
            if (widget.zoneId != null)
              Positioned(
                right: -4,
                bottom: -4,
                child: Opacity(
                  opacity: 0.35,
                  child: SizedBox(
                    width: 72,
                    height: 56,
                    child: CustomPaint(
                      painter: _MiniZoneArtPainter(widget.zoneId!),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Responsive.scale(context, 44, 54),
                    height: Responsive.scale(context, 44, 54),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.locked ? '🔒' : widget.emoji,
                        style: TextStyle(
                          fontSize: Responsive.scale(context, 24, 30),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.scale(context, 14, 17),
                        height: 1.05,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.baloo2(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Mini Lottie sticker (top-right)
            if (widget.showLottieSticker && !widget.locked)
              Positioned(
                top: -6,
                right: -4,
                child: MiniLottieSticker(
                  zoneId: widget.zoneId,
                  size: Responsive.scale(context, 42, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tiny looping Lottie badge for zone / reward stickers.
class MiniLottieSticker extends StatelessWidget {
  const MiniLottieSticker({
    super.key,
    this.zoneId,
    this.size = 44,
  });

  final String? zoneId;
  final double size;

  String get _asset {
    // Alternate assets so the grid feels varied.
    final id = zoneId ?? '';
    if (id.contains('space') ||
        id.contains('music') ||
        id.contains('puzzle') ||
        id.contains('letter')) {
      return 'assets/lottie/star_burst.json';
    }
    if (id.contains('jungle') ||
        id.contains('dino') ||
        id.contains('sport') ||
        id.contains('color')) {
      return 'assets/lottie/celebration.json';
    }
    return 'assets/lottie/lumi_happy.json';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipOval(
        child: Lottie.asset(
          _asset,
          fit: BoxFit.cover,
          repeat: true,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              zoneId == null ? '✨' : '⭐',
              style: TextStyle(fontSize: size * 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiny decorative scene peek painted on zone cards.
class _MiniZoneArtPainter extends CustomPainter {
  _MiniZoneArtPainter(this.zoneId);
  final String zoneId;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    switch (zoneId) {
      case 'space_science':
        canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.4), 8, paint);
        canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.55), 4, paint);
        return;
      case 'opposites_ocean':
        canvas.drawOval(
          Rect.fromLTWH(0, size.height * 0.45, size.width, size.height * 0.55),
          paint,
        );
        return;
      case 'music_meadow':
        canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.55), 6, paint);
        canvas.drawRect(
          Rect.fromLTWH(size.width * 0.4, size.height * 0.2, 3, 22),
          paint,
        );
        return;
      case 'number_mountain':
        final path = Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width * 0.4, size.height * 0.2)
          ..lineTo(size.width, size.height)
          ..close();
        canvas.drawPath(path, paint);
        return;
      default:
        canvas.drawCircle(
          Offset(size.width * 0.5, size.height * 0.55),
          12,
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniZoneArtPainter oldDelegate) =>
      oldDelegate.zoneId != zoneId;
}

/// Game launcher tile — chunky cartoon sticker with play button.
class KidGameTile extends StatefulWidget {
  const KidGameTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<KidGameTile> createState() => _KidGameTileState();
}

class _KidGameTileState extends State<KidGameTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppTheme.primary;
    final radius = Responsive.cardRadius(context) + 2;
    final lift = _pressed ? 2.0 : 7.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          transform: Matrix4.translationValues(0, _pressed ? 5 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: c, width: 4),
            boxShadow: [
              BoxShadow(
                color: c.withValues(alpha: 0.4),
                offset: Offset(0, lift),
                blurRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.scale(context, 14, 18),
              vertical: Responsive.scale(context, 12, 16),
            ),
            child: Row(
              children: [
                Container(
                  width: Responsive.scale(context, 64, 72),
                  height: Responsive.scale(context, 64, 72),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        c.withValues(alpha: 0.2),
                        c.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: c, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      widget.emoji,
                      style: TextStyle(
                        fontSize: Responsive.scale(context, 32, 38),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.scale(context, 14, 18)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.w700,
                          fontSize: Responsive.scale(context, 18, 22),
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.baloo2(
                          color: c,
                          fontSize: Responsive.scale(context, 13, 15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Responsive.scale(context, 48, 54),
                  height: Responsive.scale(context, 48, 54),
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: c.withValues(alpha: 0.45),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Star badge for header — candy sticker look.
class KidStarBadge extends StatelessWidget {
  const KidStarBadge({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.secondary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.45),
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
          Text(
            '$stars',
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: const Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick-action pill — chunky cartoon chip.
class KidQuickPill extends StatefulWidget {
  const KidQuickPill({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.color,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<KidQuickPill> createState() => _KidQuickPillState();
}

class _KidQuickPillState extends State<KidQuickPill> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppTheme.primary;
    final lift = _pressed ? 1.0 : 5.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c, width: 3),
          boxShadow: [
            BoxShadow(
              color: c.withValues(alpha: 0.35),
              offset: Offset(0, lift),
              blurRadius: 0,
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(
                widget.label,
                maxLines: 1,
                softWrap: false,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
