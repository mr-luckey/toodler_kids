import 'package:flutter/material.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';

class FunFactDialog {
  static Future<void> show(BuildContext context, String factKey) async {
    if (factKey.isEmpty) return;
    final show = DateTime.now().millisecond % 100 < AppConstants.funFactChancePercent;
    if (!show) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🎓 ', style: TextStyle(fontSize: 24)),
            Text('Fun Fact!'),
          ],
        ),
        content: Text(_factText(factKey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cool!'),
          ),
        ],
      ),
    );
  }

  static String _factText(String key) {
    const facts = {
      'facts.elephant.mirror':
          'Elephants can recognize themselves in a mirror — only 3 animals can do this!',
      'facts.dino.trex_arms': 'T-Rex had tiny arms but a very powerful bite!',
      'facts.space.sun_star': 'The Sun is actually a star — the closest one to Earth!',
      'facts.cow.moo': 'Cows have best friends and get stressed when separated!',
    };
    return facts[key] ?? 'Learning something new every day is amazing!';
  }
}
