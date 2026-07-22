import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/core/game_engine/level_choice_builder.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/content_repository.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';
import 'package:toodler_kids/domain/usecases/progress_usecases.dart';
import 'package:toodler_kids/core/progress/game_resume_helper.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  GamePlayBloc(
    this._getLevels,
    this._saveProgress,
    this._contentRepo,
    this._sounds,
    ProgressRepository progressRepo,
  )   : _resumeHelper = GameResumeHelper(progressRepo),
        super(const GamePlayInitial()) {
    on<GamePlayLoadRequested>(_onLoad);
    on<GamePlayAnswerSubmitted>(_onAnswer);
    on<GamePlayNextLevel>(_onNext);
    on<GamePlayDismissCelebration>(_onDismiss);
    on<GamePlayItemPlaced>(_onItemPlaced);
  }

  final GetLevelsForGame _getLevels;
  final SaveLevelProgress _saveProgress;
  final ContentRepository _contentRepo;
  final SoundManager _sounds;
  final GameResumeHelper _resumeHelper;

  List<GameLevelEntity> _levels = [];
  String? _mechanic;
  String? _gameType;
  String? _zoneId;

  Future<void> _onLoad(
    GamePlayLoadRequested event,
    Emitter<GamePlayState> emit,
  ) async {
    emit(const GamePlayLoading());
    try {
      final manifest = await _contentRepo.loadManifest();
      _mechanic = manifest.gameTypeRegistry[event.gameType]?['mechanic']
              as String? ??
          _defaultMechanic(event.gameType);

      _gameType = event.gameType;
      _zoneId = event.zoneId;
      _levels = await _getLevels(event.gameType, zoneId: event.zoneId);
      if (_levels.isEmpty) {
        emit(GamePlayError('No levels found for ${event.gameType}'));
        return;
      }
      final startIndex = await _resumeHelper.resolveStartIndex(
        sessionKey: GameResumeHelper.sessionKey(
          gameType: event.gameType,
          zoneId: event.zoneId,
        ),
        levels: _levels,
      );
      emit(_playingState(startIndex));
      await _rememberSession(startIndex);
    } catch (e) {
      emit(GamePlayError(e.toString()));
    }
  }

  Future<void> _onAnswer(
    GamePlayAnswerSubmitted event,
    Emitter<GamePlayState> emit,
  ) async {
    final current = state;
    if (current is! GamePlayPlaying) return;

    if (event.isCorrect) {
      final stars = _calcStars(current.attempts + 1, current.hintsUsed);
      await _saveProgress(
        levelId: current.level.id,
        starsEarned: stars,
        relatedConcepts: current.level.relatedConcepts,
        attempts: current.attempts + 1,
      );
      _sounds.playCelebration();
      if (current.level.gameType.contains('phonics') ||
          current.level.gameType.contains('letter')) {
        final letter = _extractLetter(current.level);
        if (letter != null) _sounds.playPhonics(letter);
      }
      emit(GamePlayCompleted(
        level: current.level,
        levelIndex: current.levelIndex,
        totalLevels: current.totalLevels,
        starsEarned: stars,
        mechanic: current.mechanic,
        funFactKey: current.level.funFactKey,
      ));
    } else {
      _sounds.playSfx('soft_boop');
      final hintsLeft = current.level.scaffoldHints - current.hintsUsed;
      String? hintId;
      if (hintsLeft > 0 &&
          (current.mechanic == 'select_piece' ||
              current.mechanic == 'tap_match' ||
              current.mechanic == 'name_match' ||
              current.mechanic == 'opposite_match')) {
        final targetId = current.mechanic == 'opposite_match'
            ? current.level.answerId
            : LevelChoiceBuilder.extractTargetId(current.level);
        if (targetId != null) {
          hintId = targetId;
        } else {
          for (final o in current.level.options) {
            if (o.isCorrect) {
              hintId = o.id;
              break;
            }
          }
        }
      }
      emit(current.copyWith(
        attempts: current.attempts + 1,
        hintsUsed: hintsLeft > 0 ? current.hintsUsed + 1 : current.hintsUsed,
        showHint: hintsLeft > 0,
        hintOptionId: hintId,
      ));
    }
  }

  void _onItemPlaced(GamePlayItemPlaced event, Emitter<GamePlayState> emit) {
    final current = state;
    if (current is! GamePlayPlaying) return;
    final placed = [...current.placedItems, event.item];
    emit(current.copyWith(placedItems: placed));
    if (placed.length >= 3) {
      add(const GamePlayAnswerSubmitted(isCorrect: true));
    }
  }

  void _onNext(GamePlayNextLevel event, Emitter<GamePlayState> emit) {
    final current = state;
    int next = 0;
    if (current is GamePlayCompleted) {
      next = current.levelIndex + 1;
    } else if (current is GamePlayPlaying) {
      next = current.levelIndex + 1;
    } else {
      return;
    }
    if (next >= _levels.length) {
      emit(const GamePlayAllDone());
      return;
    }
    emit(_playingState(next));
    _rememberSession(next);
  }

  Future<void> _rememberSession(int index) async {
    final gameType = _gameType;
    if (gameType == null) return;
    await _resumeHelper.rememberLevel(
      GameResumeHelper.sessionKey(gameType: gameType, zoneId: _zoneId),
      index,
    );
  }

  void _onDismiss(
    GamePlayDismissCelebration event,
    Emitter<GamePlayState> emit,
  ) {
    add(const GamePlayNextLevel());
  }

  GamePlayPlaying _playingState(int index) {
    final level = _levels[index];
    final mechanic = _mechanic ?? 'tap_match';
    return GamePlayPlaying(
      level: level,
      levelIndex: index,
      totalLevels: _levels.length,
      mechanic: mechanic,
      prompt: _resolvePrompt(level.lumiLineKey, level, mechanic),
      choices: LevelChoiceBuilder.buildChoices(level),
      attempts: 0,
      hintsUsed: 0,
      placedItems: [],
    );
  }

  int _calcStars(int attempts, int hintsUsed) {
    if (attempts <= 1 && hintsUsed == 0) return 3;
    if (attempts <= 2 && hintsUsed <= 1) return 2;
    return 1;
  }

  String _defaultMechanic(String gameType) {
    const map = {
      'complete_picture': 'select_piece',
      'shadow_game': 'drag_drop',
      'what_am_i': 'riddle',
      'true_false': 'true_false',
      'true_false_animals': 'true_false',
      'true_false_math': 'true_false',
      'true_false_dino': 'true_false',
      'true_false_space': 'true_false',
      'true_false_world': 'true_false',
      'build_scene': 'sandbox',
      'story_order': 'sequence',
      'simon_says': 'simon',
      'which_tool_works': 'tap_match',
      'opposites': 'opposite_match',
      'fun_colors': 'tap_match',
      'animal_names': 'name_match',
      'counting': 'count_match',
      'letter_phonics': 'phonics_match',
      'color_recognition': 'name_match',
    };
    return map[gameType] ?? 'tap_match';
  }

  String _resolvePrompt(
    String? raw,
    GameLevelEntity level,
    String mechanic,
  ) {
    final fallback = _defaultPrompt(level, mechanic);
    if (raw == null || raw.isEmpty) return fallback;
    // Content sometimes stores localization keys instead of kid-facing text.
    const known = {
      'lumi.complete_picture.hint': 'Put the pieces together! 🧩',
      'lumi.which_tool.hint': 'Which tool works?',
      'lumi.shadow.hint': 'Match the shadow!',
      'lumi.tap_match.hint': 'Tap the correct one!',
    };
    if (known.containsKey(raw)) return known[raw]!;
    if (raw.startsWith('lumi.')) return fallback;
    return raw;
  }

  String _defaultPrompt(GameLevelEntity level, String mechanic) {
    if (mechanic == 'true_false') {
      final statement = level.statementKey;
      if (statement != null &&
          statement.isNotEmpty &&
          !statement.startsWith('lumi.')) {
        return statement;
      }
      return 'Is this true?';
    }
    if (mechanic == 'riddle' && level.clues.isNotEmpty) {
      return level.clues.first;
    }
    if (mechanic == 'select_piece') return 'Put the pieces together! 🧩';
    return 'Tap the correct one!';
  }

  String? _extractLetter(GameLevelEntity level) {
    for (final o in level.options) {
      if (o.isCorrect && o.id.startsWith('letter_')) {
        return o.id.replaceAll('letter_', '');
      }
    }
    for (final item in level.items) {
      final id = item['id']?.toString() ?? '';
      if (id.startsWith('letter_')) return id.replaceAll('letter_', '');
    }
    return null;
  }
}
