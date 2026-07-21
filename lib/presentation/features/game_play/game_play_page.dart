import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/game_engine/game_engines.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/core/game_engine/level_choice_builder.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/presentation/features/game_play/bloc/game_play_bloc.dart';
import 'package:toodler_kids/presentation/lumi/lumi_widget.dart';
import 'package:toodler_kids/presentation/widgets/cartoon_game_widgets.dart';
import 'package:toodler_kids/presentation/widgets/fun_fact_dialog.dart';
import 'package:toodler_kids/presentation/widgets/kid_ui.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({
    super.key,
    required this.gameType,
    this.zoneId,
    this.title,
  });

  final String gameType;
  final String? zoneId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamePlayBloc>()
        ..add(GamePlayLoadRequested(gameType: gameType, zoneId: zoneId)),
      child: _GamePlayView(
        title: title ?? GamePlayPage.titleFor(gameType),
        zoneId: zoneId,
      ),
    );
  }

  static String titleFor(String type) {
    const titles = {
      'animal_world': 'Animal World',
      'animal_names': 'Animal Names',
      'number_recognition': 'Numbers',
      'letter_recognition': 'Letters',
      'shadow_game': 'Shadow Game',
      'what_am_i': 'What Am I?',
      'true_false_animals': 'True or False',
      'dino_names': 'Dinosaur Names',
      'space_objects': 'Space Objects',
      'sports_names': 'Sports',
      'four_seasons': 'Seasons',
      'household_items': 'Household Items',
      'which_tool_works': 'Which Tool Works?',
      'complete_picture': 'Complete Picture',
      'opposites': 'Opposites',
      'fun_colors': 'Fun Colors',
    };
    return titles[type] ?? type.replaceAll('_', ' ');
  }
}

class _GamePlayView extends StatelessWidget {
  const _GamePlayView({required this.title, this.zoneId});
  final String title;
  final String? zoneId;

  String get _zoneForTheme {
    if (zoneId != null) return zoneId!;
    if (title.toLowerCase().contains('dino')) return 'dinosaurs';
    if (title.toLowerCase().contains('space')) return 'space_science';
    if (title.toLowerCase().contains('number')) return 'number_mountain';
    if (title.toLowerCase().contains('letter')) return 'letter_lane';
    if (title.toLowerCase().contains('color')) return 'color_canyon';
    if (title.toLowerCase().contains('sport')) return 'sports_body';
    return 'jungle_grove';
  }

  @override
  Widget build(BuildContext context) {
    return ZoneGameScaffold(
      zoneId: _zoneForTheme,
      title: title,
      onBack: () => context.pop(),
      body: BlocConsumer<GamePlayBloc, GamePlayState>(
          listener: (context, state) {
            if (state is GamePlayCompleted && state.funFactKey != null) {
              FunFactDialog.show(context, state.funFactKey!);
            }
          },
          builder: (context, state) {
            if (state is GamePlayLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GamePlayError) {
              return KidScreenBody(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LumiWidget(
                      emotion: LumiEmotion.sad,
                      message: 'Oops! Something went wrong.',
                    ),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }
            if (state is GamePlayAllDone) {
              return KidScreenBody(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LumiWidget(
                      emotion: LumiEmotion.proud,
                      message: 'Amazing! All levels complete!',
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
            if (state is GamePlayCompleted) {
              return CelebrationOverlay(
                stars: state.starsEarned,
                onDismiss: () => context.read<GamePlayBloc>().add(
                      const GamePlayDismissCelebration(),
                    ),
              );
            }
            if (state is GamePlayPlaying) {
              return Column(
                children: [
                  _ProgressBar(
                    current: state.levelIndex + 1,
                    total: state.totalLevels,
                  ),
                  Expanded(child: _GameBody(state: state, zoneId: zoneId)),
                ],
              );
            }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.pad(context),
        8,
        Responsive.pad(context),
        4,
      ),
      child: Column(
        children: [
          Text(
            'Level $current / $total',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: Colors.grey.shade200,
              color: AppTheme.primary,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody({required this.state, this.zoneId});
  final GamePlayPlaying state;
  final String? zoneId;

  bool get _needsExpanded =>
      state.mechanic == 'select_piece' ||
      state.mechanic == 'sandbox' ||
      state.mechanic == 'sequence';

  @override
  Widget build(BuildContext context) {
    final engine = _buildEngine(context);
    if (_needsExpanded) return engine;
    return KidGameShell(child: engine);
  }

  Widget _buildEngine(BuildContext context) {
    final bloc = context.read<GamePlayBloc>();
    final zone = zoneId ?? 'jungle_grove';

    switch (state.mechanic) {
      case 'select_piece':
        return SelectPieceEngine(
          level: state.level,
          hintOptionId: state.showHint ? state.hintOptionId : null,
          accentColor: ZoneVisualTheme.forZone(zone).primary,
          onPieceSelected: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      case 'true_false':
        return TrueFalseEngine(
          statement: state.prompt,
          onAnswer: (answer) {
            final correct = state.level.isTrue == answer;
            bloc.add(GamePlayAnswerSubmitted(isCorrect: correct));
          },
        );
      case 'riddle':
        return RiddleEngine(
          clues: state.level.clues.isNotEmpty ? state.level.clues : [state.prompt],
          choices: state.choices,
          answerId: state.level.answerId ?? '',
          onGuess: (choiceId, _) {
            bloc.add(GamePlayAnswerSubmitted(
              isCorrect: choiceId == state.level.answerId,
              choiceId: choiceId,
            ));
          },
        );
      case 'drag_drop':
        final item = state.level.items.isNotEmpty
            ? state.level.items.first
            : {'id': 'drag', 'emoji': '🖼️', 'label': 'Item'};
        final targets =
            state.level.bins.isNotEmpty ? state.level.bins : state.choices;
        return DragDropEngine(
          draggableItem: item,
          targets: targets,
          onDropped: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      case 'sandbox':
        return SandboxEngine(
          backgroundEmoji: state.level.backgroundImage ?? '🌾',
          itemTray: state.level.itemTray.isNotEmpty
              ? state.level.itemTray
              : state.choices,
          placedItems: state.placedItems,
          onItemPlaced: (item, pos) {
            bloc.add(GamePlayItemPlaced({...item, 'x': pos.dx, 'y': pos.dy}));
          },
        );
      case 'sequence':
        return SequenceEngine(
          items: state.level.sequenceItems.isNotEmpty
              ? state.level.sequenceItems
              : state.choices,
          onComplete: (correct) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: correct));
          },
        );
      case 'simon':
        return SimonEngine(
          sequence: const [0, 1, 0],
          colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
          onComplete: (success) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: success));
          },
        );
      case 'name_match':
        final zoneTheme = ZoneVisualTheme.forZone(zone);
        final target = LevelChoiceBuilder.targetDisplay(state.level);
        if (target == null) {
          return TapMatchEngine(
            prompt: state.prompt,
            choices: state.choices,
            showHint: state.showHint,
            hintOptionId: state.hintOptionId,
            accentColor: zoneTheme.primary,
            onChoice: (_, isCorrect) {
              bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
            },
          );
        }
        return NameMatchEngine(
          prompt: state.prompt,
          target: target,
          choices: state.choices,
          showHint: state.showHint,
          hintOptionId: state.hintOptionId,
          accentColor: zoneTheme.primary,
          onChoice: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      default:
        final zoneTheme = ZoneVisualTheme.forZone(zone);
        final showHero = state.level.extra['mode'] != 'quick_tap';
        return TapMatchEngine(
          prompt: state.prompt,
          choices: state.choices,
          target: showHero ? LevelChoiceBuilder.targetDisplay(state.level) : null,
          showHint: state.showHint,
          hintOptionId: state.hintOptionId,
          accentColor: zoneTheme.primary,
          onChoice: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
    }
  }
}
