import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/usecases/progress_usecases.dart';
import 'package:toodler_kids/presentation/lumi/lumi_widget.dart';
import 'package:toodler_kids/presentation/widgets/kid_ui.dart';

class AgeSelectionPage extends StatefulWidget {
  const AgeSelectionPage({super.key});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  AgeTier? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
          ),
        ),
        child: KidScreenBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: LumiWidget(
                  emotion: LumiEmotion.excited,
                  message: 'Hi! I am Lumi. Let us pick your age!',
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'How old is your little explorer?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ...AgeTier.values.map((tier) => _AgeCard(
                    tier: tier,
                    selected: _selected == tier,
                    onTap: () => setState(() => _selected = tier),
                  )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _selected == null ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primary,
                  disabledBackgroundColor: Colors.white38,
                ),
                child: const Text('Start Adventure!'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_selected == null) return;
    final saveProfile = SaveChildProfile(getIt());
    await saveProfile(ChildProfileEntity(
      name: 'Explorer',
      ageTierId: _selected!.id,
      totalStars: 0,
      totalSessions: 1,
      unlockedZones: ['jungle_grove', 'number_mountain', 'letter_lane'],
      earnedBadges: [],
      conceptMastery: {},
    ));
    if (mounted) context.go('/home');
  }
}

class _AgeCard extends StatelessWidget {
  const _AgeCard({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final AgeTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.white : Colors.white54,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(_emojiForTier(tier), style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _labelForTier(tier),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: selected ? AppTheme.primary : Colors.white,
                    ),
                  ),
                  Text(
                    '${tier.minAge}–${tier.maxAge} years',
                    style: TextStyle(
                      color: selected ? Colors.grey.shade600 : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppTheme.primary, size: 28),
          ],
        ),
      ),
    );
  }

  String _emojiForTier(AgeTier tier) {
    switch (tier) {
      case AgeTier.tinyExplorers:
        return '👶';
      case AgeTier.littleLearners:
        return '🧒';
      case AgeTier.juniorScholars:
        return '🎓';
    }
  }

  String _labelForTier(AgeTier tier) {
    switch (tier) {
      case AgeTier.tinyExplorers:
        return 'Tiny Explorers';
      case AgeTier.littleLearners:
        return 'Little Learners';
      case AgeTier.juniorScholars:
        return 'Junior Scholars';
    }
  }
}
