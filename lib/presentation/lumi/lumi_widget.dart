import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';

class LumiWidget extends StatelessWidget {
  const LumiWidget({
    super.key,
    this.emotion = LumiEmotion.happy,
    this.message,
    this.size = 80,
    this.onTap,
    this.compact = false,
    this.useLottie = true,
  });

  final LumiEmotion emotion;
  final String? message;
  final double size;
  final VoidCallback? onTap;
  final bool compact;
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    final avatar = GestureDetector(
      onTap: onTap,
      child: _LumiAvatar(
        emotion: emotion,
        size: size,
        useLottie: useLottie,
      ),
    );

    if (message == null) return avatar;

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _emotionColor(emotion), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: _emotionColor(emotion).withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        message!,
        maxLines: compact ? 2 : 4,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.baloo2(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );

    if (compact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar,
          const SizedBox(width: 10),
          Expanded(child: bubble),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(height: 8),
        bubble,
      ],
    );
  }

  Color _emotionColor(LumiEmotion emotion) {
    switch (emotion) {
      case LumiEmotion.happy:
        return const Color(0xFFFFD54F);
      case LumiEmotion.sad:
        return const Color(0xFF90CAF9);
      case LumiEmotion.excited:
        return const Color(0xFFFF7043);
      case LumiEmotion.proud:
        return const Color(0xFFAB47BC);
      case LumiEmotion.thinking:
        return const Color(0xFF78909C);
      case LumiEmotion.surprised:
        return const Color(0xFF4DD0E1);
      case LumiEmotion.encouraging:
        return const Color(0xFF66BB6A);
      case LumiEmotion.sleepy:
        return const Color(0xFFB39DDB);
    }
  }
}

class _LumiAvatar extends StatelessWidget {
  const _LumiAvatar({
    required this.emotion,
    required this.size,
    required this.useLottie,
  });

  final LumiEmotion emotion;
  final double size;
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    if (useLottie && (emotion == LumiEmotion.happy || emotion == LumiEmotion.proud)) {
      return SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/lottie/lumi_happy.json',
          fit: BoxFit.contain,
          repeat: true,
          errorBuilder: (context, error, stackTrace) => _emojiAvatar(),
        ),
      );
    }
    return _emojiAvatar();
  }

  Widget _emojiAvatar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _colorFor(emotion),
            _colorFor(emotion).withValues(alpha: 0.65),
          ],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: _colorFor(emotion).withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(_emojiFor(emotion), style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }

  Color _colorFor(LumiEmotion e) => switch (e) {
        LumiEmotion.happy => const Color(0xFFFFD54F),
        LumiEmotion.sad => const Color(0xFF90CAF9),
        LumiEmotion.excited => const Color(0xFFFF7043),
        LumiEmotion.proud => const Color(0xFFAB47BC),
        LumiEmotion.thinking => const Color(0xFF78909C),
        LumiEmotion.surprised => const Color(0xFF4DD0E1),
        LumiEmotion.encouraging => const Color(0xFF66BB6A),
        LumiEmotion.sleepy => const Color(0xFFB39DDB),
      };

  String _emojiFor(LumiEmotion e) => switch (e) {
        LumiEmotion.happy => '⭐',
        LumiEmotion.sad => '💫',
        LumiEmotion.excited => '🌟',
        LumiEmotion.proud => '✨',
        LumiEmotion.thinking => '🤔',
        LumiEmotion.surprised => '😮',
        LumiEmotion.encouraging => '👍',
        LumiEmotion.sleepy => '😴',
      };
}

class LumiScaffoldHelper extends StatelessWidget {
  const LumiScaffoldHelper({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.paddingOf(context).bottom + 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const LumiWidget(emotion: LumiEmotion.encouraging, size: 44),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
