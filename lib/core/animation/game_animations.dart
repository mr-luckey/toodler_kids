import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';

/// Montessori-style bounce-back animation for wrong answers.
class BounceBackAnimation extends StatefulWidget {
  const BounceBackAnimation({
    super.key,
    required this.child,
    required this.trigger,
    this.onComplete,
  });

  final Widget child;
  final int trigger;
  final VoidCallback? onComplete;

  @override
  State<BounceBackAnimation> createState() => _BounceBackAnimationState();
}

class _BounceBackAnimationState extends State<BounceBackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 8.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(BounceBackAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.forward(from: 0).then((_) => widget.onComplete?.call());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({
    super.key,
    required this.stars,
    required this.onDismiss,
  });

  final int stars;
  final VoidCallback onDismiss;

  String get _message => switch (stars) {
        3 => 'Superstar! 🌟',
        2 => 'Great job!',
        _ => 'Nice try! Keep going!',
      };

  String get _lottieAsset => switch (stars) {
        3 => 'assets/lottie/lumi_happy.json',
        2 => 'assets/lottie/celebration.json',
        _ => 'assets/lottie/star_burst.json',
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppTheme.primary, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                offset: const Offset(0, 8),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: Lottie.asset(
                  _lottieAsset,
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) =>
                      Text('🎉', style: TextStyle(fontSize: stars >= 3 ? 72 : 64)),
                ),
              ),
              Text(
                _message,
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppTheme.secondary,
                      size: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onDismiss,
                child: Text(
                  'Continue!',
                  style: GoogleFonts.baloo2(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Brief inline pop when a child picks the correct answer (no full Lottie).
class CorrectAnswerBurst extends StatelessWidget {
  const CorrectAnswerBurst({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return IgnorePointer(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.4, end: 1.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.secondary.withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text('⭐', style: TextStyle(fontSize: 48)),
          ),
        ),
      ),
    );
  }
}

class ScaffoldHintGlow extends StatelessWidget {
  const ScaffoldHintGlow({
    super.key,
    required this.child,
    required this.showGlow,
  });

  final Widget child;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppTheme.secondary.withValues(alpha: 0.9),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ]
            : [],
      ),
      child: child,
    );
  }
}
