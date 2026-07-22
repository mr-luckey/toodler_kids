import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';
import 'package:toodler_kids/core/progress/game_resume_helper.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';
import 'package:toodler_kids/domain/usecases/progress_usecases.dart';

part 'complete_picture_event.dart';
part 'complete_picture_state.dart';

class CompletePictureBloc extends Bloc<CompletePictureEvent, CompletePictureState> {
  CompletePictureBloc(
    this._getLevels,
    this._saveProgress,
    this._sounds,
    ProgressRepository progressRepo,
  )   : _resumeHelper = GameResumeHelper(progressRepo),
        super(const CompletePictureInitial()) {
    on<CompletePictureLoadRequested>(_onLoad);
    on<CompletePicturePieceSelected>(_onPieceSelected);
    on<CompletePictureNextLevel>(_onNextLevel);
    on<CompletePictureDismissCelebration>(_onDismiss);
  }

  final GetLevelsForGame _getLevels;
  final SaveLevelProgress _saveProgress;
  final SoundManager _sounds;
  final GameResumeHelper _resumeHelper;
  List<GameLevelEntity> _levels = [];
  static const _sessionKey = 'complete_picture';

  Future<void> _onLoad(
    CompletePictureLoadRequested event,
    Emitter<CompletePictureState> emit,
  ) async {
    emit(const CompletePictureLoading());
    _levels = await _getLevels('complete_picture');
    if (_levels.isEmpty) {
      emit(const CompletePictureError('No levels found'));
      return;
    }
    final startIndex = await _resumeHelper.resolveStartIndex(
      sessionKey: _sessionKey,
      levels: _levels,
    );
    emit(CompletePicturePlaying(
      level: _levels[startIndex],
      levelIndex: startIndex,
      totalLevels: _levels.length,
      attempts: 0,
      hintsUsed: 0,
    ));
    await _resumeHelper.rememberLevel(_sessionKey, startIndex);
  }

  Future<void> _onPieceSelected(
    CompletePicturePieceSelected event,
    Emitter<CompletePictureState> emit,
  ) async {
    final current = state;
    if (current is! CompletePicturePlaying) return;

    if (event.isCorrect) {
      final stars = _calculateStars(current.attempts + 1, current.hintsUsed);
      await _saveProgress(
        levelId: current.level.id,
        starsEarned: stars,
        relatedConcepts: current.level.relatedConcepts,
        attempts: current.attempts + 1,
      );
      await _sounds.playCelebration();
      emit(CompletePictureCompleted(
        level: current.level,
        levelIndex: current.levelIndex,
        totalLevels: current.totalLevels,
        starsEarned: stars,
        showFunFact: current.level.funFactKey != null,
        funFactKey: current.level.funFactKey,
      ));
    } else {
      await _sounds.playSfx('soft_boop');
      final hintsAvailable = current.level.scaffoldHints - current.hintsUsed;
      emit(current.copyWith(
        attempts: current.attempts + 1,
        hintsUsed: hintsAvailable > 0 ? current.hintsUsed + 1 : current.hintsUsed,
        showHint: hintsAvailable > 0,
        hintOptionId: hintsAvailable > 0
            ? current.level.options.firstWhere((o) => o.isCorrect).id
            : null,
      ));
    }
  }

  void _onNextLevel(
    CompletePictureNextLevel event,
    Emitter<CompletePictureState> emit,
  ) {
    final current = state;
    int nextIndex = 0;
    if (current is CompletePictureCompleted) {
      nextIndex = current.levelIndex + 1;
    } else if (current is CompletePicturePlaying) {
      nextIndex = current.levelIndex + 1;
    } else {
      return;
    }

    if (nextIndex >= _levels.length) {
      emit(const CompletePictureAllDone());
      return;
    }

    emit(CompletePicturePlaying(
      level: _levels[nextIndex],
      levelIndex: nextIndex,
      totalLevels: _levels.length,
      attempts: 0,
      hintsUsed: 0,
    ));
    _resumeHelper.rememberLevel(_sessionKey, nextIndex);
  }

  void _onDismiss(
    CompletePictureDismissCelebration event,
    Emitter<CompletePictureState> emit,
  ) {
    add(const CompletePictureNextLevel());
  }

  int _calculateStars(int attempts, int hintsUsed) {
    if (attempts <= 1 && hintsUsed == 0) return 3;
    if (attempts <= 2 && hintsUsed <= 1) return 2;
    return 1;
  }
}
