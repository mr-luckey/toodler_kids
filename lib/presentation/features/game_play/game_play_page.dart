import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/core/game_engine/game_engines.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/core/assets/game_image_resolver.dart';
import 'package:toodler_kids/core/game_engine/piece_puzzle_engine.dart';
import 'package:toodler_kids/core/game_engine/level_choice_builder.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
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
      'true_false_world': 'World Facts',
      'dino_names': 'Dinosaur Names',
      'space_objects': 'Space Objects',
      'sports_names': 'Sports',
      'four_seasons': 'Seasons',
      'household_items': 'Household Items',
      'which_tool_works': 'Which Tool Works?',
      'complete_picture': 'Complete Picture',
      'opposites': 'Opposites',
      'fun_colors': 'Fun Colors',
      'simon_says': 'Simon Says',
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
              final zoneTheme = ZoneVisualTheme.forZone(_zoneForTheme);
              return Column(
                children: [
                  _ProgressBar(
                    current: state.levelIndex + 1,
                    total: state.totalLevels,
                    lightText: zoneTheme.isDark,
                  ),
                  Expanded(
                    child: Responsive.centeredContent(
                      context,
                      _GameBody(state: state, zoneId: zoneId),
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.current,
    required this.total,
    this.lightText = false,
  });
  final int current;
  final int total;
  final bool lightText;

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: lightText ? Colors.white : null,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: lightText ? Colors.white24 : Colors.grey.shade200,
              color: lightText ? Colors.amber : AppTheme.primary,
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
      state.mechanic == 'sequence' ||
      state.mechanic == 'tap_match' ||
      state.mechanic == 'name_match' ||
      state.mechanic == 'count_match' ||
      state.mechanic == 'phonics_match' ||
      state.mechanic == 'opposite_match' ||
      state.mechanic == 'simon';

  @override
  Widget build(BuildContext context) {
    final engine = _buildEngine(context);
    if (_needsExpanded) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.pad(context)),
        child: engine,
      );
    }
    return KidGameShell(child: engine);
  }

  Widget _buildEngine(BuildContext context) {
    final bloc = context.read<GamePlayBloc>();
    final zone = zoneId ?? 'jungle_grove';

    switch (state.mechanic) {
      case 'select_piece':
        if (state.level.gameType == 'complete_picture') {
          return PiecePuzzleEngine(
            level: state.level,
            prompt: state.prompt,
            accentColor: ZoneVisualTheme.forZone(zone).primary,
            onComplete: () {
              bloc.add(const GamePlayAnswerSubmitted(isCorrect: true));
            },
          );
        }
        // Tools / other select_piece → tap-style choices (no puzzle board).
        return TapMatchEngine(
          prompt: state.prompt,
          choices: state.choices.isNotEmpty
              ? state.choices
              : state.level.options
                  .map(
                    (o) => {
                      'id': o.id,
                      'label': o.labelKey ?? o.id,
                      'emoji': LevelChoiceBuilder.emojiForId(o.id),
                      'imagePath': GameImageResolver.assetForId(o.id) ??
                          GameImageResolver.assetFromImagePath(o.image),
                      'isCorrect': o.isCorrect,
                    },
                  )
                  .toList(),
          showHint: state.showHint,
          hintOptionId: state.hintOptionId,
          accentColor: ZoneVisualTheme.forZone(zone).primary,
          onChoice: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      case 'drag_drop':
        final label = state.level.items.isNotEmpty
            ? (state.level.items.first['label']?.toString() ?? 'animal')
            : 'animal';
        final subjectPath = GameImageResolver.themeFromLevel(
              referenceImage: state.level.referenceImage,
              relatedConcepts: state.level.relatedConcepts,
            ) ??
            GameImageResolver.assetForId(label);
        final subjectEmoji = LevelChoiceBuilder.emojiForId(label);
        const decoyPool = [
          'lion', 'elephant', 'giraffe', 'monkey', 'cow', 'sheep', 'pig', 'bear',
          'duck', 'frog', 'penguin', 'shark', 'butterfly', 'trex', 'rocket', 'moon',
          'sun', 'football', 'hammer', 'red', 'blue', 'green',
        ];
        final levelNo = state.level.levelNumber;
        final item = {
          'id': 'drag',
          'emoji': subjectEmoji,
          'label': label,
          'imagePath': subjectPath,
        };
        final rawBins = state.level.bins.isNotEmpty
            ? state.level.bins
            : [
                {'id': 'correct', 'acceptsId': 'drag', 'label': 'Shadow'},
                {'id': 'wrong1', 'acceptsId': 'wrong', 'label': 'Wrong'},
              ];
        final targets = rawBins.map((t) {
          final accepts = t['acceptsId']?.toString();
          final isCorrect = accepts == 'drag' || accepts == item['id'];
          final candidates =
              decoyPool.where((id) => id != label.toLowerCase()).toList();
          final decoyId = (t['decoyId'] as String?) ??
              candidates[(levelNo * 7) % candidates.length];
          return {
            ...t,
            if (!isCorrect) 'decoyId': decoyId,
            'emoji': isCorrect
                ? subjectEmoji
                : LevelChoiceBuilder.emojiForId(decoyId),
          };
        }).toList()
          ..shuffle(math.Random(levelNo * 17 + label.hashCode));
        return DragDropEngine(
          draggableItem: item,
          targets: targets,
          subjectImagePath: subjectPath,
          prompt: state.prompt.isNotEmpty && !state.prompt.startsWith('lumi.')
              ? state.prompt
              : 'Match the shadow!',
          accentColor: ZoneVisualTheme.forZone(zone).primary,
          onDropped: (_, isCorrect) {
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
        final sequence = (state.level.extra['simonSequence'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            const [0, 1, 0];
        final pads = state.level.sequenceItems.isNotEmpty
            ? state.level.sequenceItems
            : const [
                {'id': '0', 'emoji': '🥁', 'label': 'Drum', 'color': '#E53935'},
                {'id': '1', 'emoji': '🎹', 'label': 'Piano', 'color': '#1E88E5'},
                {'id': '2', 'emoji': '🎸', 'label': 'Guitar', 'color': '#43A047'},
                {'id': '3', 'emoji': '🎺', 'label': 'Trumpet', 'color': '#FFB300'},
              ];
        return SimonEngine(
          prompt: state.prompt,
          sequence: sequence,
          pads: pads,
          onPadSound: (index) => getIt<SoundManager>().playSimonPad(index),
          onComplete: (success) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: success));
          },
        );
      case 'count_match':
        final zoneTheme = ZoneVisualTheme.forZone(zone);
        final count = LevelChoiceBuilder.countVisual(state.level) ?? 1;
        return CountMatchEngine(
          prompt: state.prompt,
          count: count,
          countEmoji: LevelChoiceBuilder.countEmoji(state.level),
          choices: state.choices,
          showHint: state.showHint,
          hintOptionId: state.hintOptionId,
          accentColor: zoneTheme.primary,
          onChoice: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      case 'phonics_match':
        final zoneTheme = ZoneVisualTheme.forZone(zone);
        return _PhonicsMatchHost(
          level: state.level,
          prompt: state.prompt,
          choices: state.choices,
          showHint: state.showHint,
          hintOptionId: state.hintOptionId,
          accentColor: zoneTheme.primary,
          onChoice: (_, isCorrect) {
            bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
          },
        );
      case 'opposite_match':
        final zoneTheme = ZoneVisualTheme.forZone(zone);
        final source = LevelChoiceBuilder.sourceDisplay(state.level);
        if (source != null) {
          return NameMatchEngine(
            prompt: state.prompt,
            target: source,
            choices: state.choices,
            showHint: state.showHint,
            hintOptionId: state.hintOptionId,
            accentColor: zoneTheme.primary,
            heroHeader: 'Opposite of this!',
            onChoice: (_, isCorrect) {
              bloc.add(GamePlayAnswerSubmitted(isCorrect: isCorrect));
            },
          );
        }
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
        final isToolQuiz = state.level.gameType == 'which_tool_works';
        final showHero = !isToolQuiz && state.level.extra['mode'] != 'quick_tap';
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

class _PhonicsMatchHost extends StatefulWidget {
  const _PhonicsMatchHost({
    required this.level,
    required this.prompt,
    required this.choices,
    required this.onChoice,
    this.showHint = false,
    this.hintOptionId,
    this.accentColor,
  });

  final GameLevelEntity level;
  final String prompt;
  final List<Map<String, dynamic>> choices;
  final void Function(String choiceId, bool isCorrect) onChoice;
  final bool showHint;
  final String? hintOptionId;
  final Color? accentColor;

  @override
  State<_PhonicsMatchHost> createState() => _PhonicsMatchHostState();
}

class _PhonicsMatchHostState extends State<_PhonicsMatchHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSound());
  }

  @override
  void didUpdateWidget(covariant _PhonicsMatchHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.id != widget.level.id) {
      _playSound();
    }
  }

  void _playSound() {
    final targetId = LevelChoiceBuilder.extractTargetId(widget.level);
    if (targetId != null && targetId.startsWith('letter_')) {
      final letter = targetId.replaceAll('letter_', '');
      getIt<SoundManager>().playPhonics(letter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NameMatchEngine(
      prompt: widget.prompt,
      target: const {'emoji': '🔊', 'label': 'Listen!'},
      choices: widget.choices,
      showHint: widget.showHint,
      hintOptionId: widget.hintOptionId,
      accentColor: widget.accentColor,
      onChoice: widget.onChoice,
    );
  }
}
