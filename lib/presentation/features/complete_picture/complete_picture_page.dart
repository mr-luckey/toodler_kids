import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/game_engine/game_engines.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/presentation/features/complete_picture/bloc/complete_picture_bloc.dart';
import 'package:toodler_kids/presentation/lumi/lumi_widget.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/presentation/widgets/cartoon_game_widgets.dart';
import 'package:toodler_kids/presentation/widgets/fun_fact_dialog.dart';
import 'package:toodler_kids/presentation/widgets/kid_ui.dart';

class CompletePicturePage extends StatelessWidget {
  const CompletePicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CompletePictureBloc>()..add(const CompletePictureLoadRequested()),
      child: const _CompletePictureView(),
    );
  }
}

class _CompletePictureView extends StatelessWidget {
  const _CompletePictureView();

  static const _theme = ZoneVisualTheme(
    id: 'puzzle_palace',
    primary: Color(0xFF7E57C2),
    accent: Color(0xFFFF7043),
    background: Color(0xFFEDE7F6),
    hubGradient: [Color(0xFF9575CD), Color(0xFF512DA8)],
    screenGradient: [Color(0xFFD1C4E9), Color(0xFFEDE7F6), Color(0xFFFFF8E1)],
    decorations: [ZoneDecoration.sparkles],
    cardBorderColor: Color(0xFF512DA8),
  );

  @override
  Widget build(BuildContext context) {
    return ZoneGameScaffold(
      zoneId: 'puzzle_palace',
      title: 'Complete Picture 🧩',
      onBack: () => context.pop(),
      body: BlocConsumer<CompletePictureBloc, CompletePictureState>(
        listener: (context, state) {
          if (state is CompletePictureCompleted && state.showFunFact) {
            FunFactDialog.show(context, state.funFactKey ?? '');
          }
        },
        builder: (context, state) {
          if (state is CompletePictureLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompletePictureError) {
            return KidScreenBody(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LumiWidget(
                    emotion: LumiEmotion.sad,
                    message: 'Oops! Could not load puzzles.',
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          if (state is CompletePictureAllDone) {
            return KidScreenBody(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LumiWidget(
                    emotion: LumiEmotion.proud,
                    message: 'You completed all 500 puzzles! Amazing!',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back to Island'),
                  ),
                ],
              ),
            );
          }
          if (state is CompletePictureCompleted) {
            return CelebrationOverlay(
              stars: state.starsEarned,
              onDismiss: () => context.read<CompletePictureBloc>().add(
                    const CompletePictureDismissCelebration(),
                  ),
            );
          }
          if (state is CompletePicturePlaying) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: const LumiWidget(
                    emotion: LumiEmotion.thinking,
                    message: 'Tap the piece that fits the puzzle!',
                    size: 44,
                    compact: true,
                  ),
                ),
                CartoonProgressBar(
                  current: state.levelIndex + 1,
                  total: state.totalLevels,
                  accent: _theme.primary,
                ),
                Expanded(
                  child: SelectPieceEngine(
                    level: state.level,
                    hintOptionId: state.showHint ? state.hintOptionId : null,
                    accentColor: _theme.primary,
                    prompt: 'Find the missing piece! 🧩',
                    onPieceSelected: (_, isCorrect) {
                      context.read<CompletePictureBloc>().add(
                            CompletePicturePieceSelected(isCorrect: isCorrect),
                          );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
