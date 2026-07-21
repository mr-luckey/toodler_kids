import 'package:flutter/material.dart';
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - pad.vertical),
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

/// Colorful zone card for Wonder Island grid.
class KidZoneCard extends StatelessWidget {
  const KidZoneCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.primary,
    required this.accent,
    required this.onTap,
    this.locked = false,
    this.subtitle,
  });

  final String emoji;
  final String title;
  final Color primary;
  final Color accent;
  final VoidCallback? onTap;
  final bool locked;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final radius = Responsive.cardRadius(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: locked
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [primary, Color.lerp(primary, accent, 0.45)!],
            ),
            boxShadow: [
              BoxShadow(
                color: (locked ? Colors.grey : primary).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locked ? '🔒' : emoji,
                      style: TextStyle(
                        fontSize: Responsive.scale(context, 36, 44),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: Responsive.scale(context, 14, 16),
                        height: 1.15,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (locked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle ?? 'Locked',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Game launcher tile inside zone detail.
class KidGameTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.play_circle_fill, color: c, size: 36),
            ],
          ),
        ),
      ),
    );
  }
}

/// Star badge for header.
class KidStarBadge extends StatelessWidget {
  const KidStarBadge({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppTheme.secondary, size: 22),
          const SizedBox(width: 4),
          Text(
            '$stars',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// Quick-action pill button.
class KidQuickPill extends StatelessWidget {
  const KidQuickPill({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
