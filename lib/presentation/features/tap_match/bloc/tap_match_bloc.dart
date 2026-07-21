import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/game_engine/level_choice_builder.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';
import 'package:toodler_kids/domain/usecases/progress_usecases.dart';

part 'tap_match_event.dart';
part 'tap_match_state.dart';

class TapMatchBloc extends Bloc<TapMatchEvent, TapMatchState> {
  TapMatchBloc(this._getLevels, this._saveProgress)
      : super(const TapMatchInitial()) {
    on<TapMatchLoadRequested>(_onLoad);
    on<TapMatchChoiceMade>(_onChoice);
    on<TapMatchNextLevel>(_onNext);
  }

  final GetLevelsForGame _getLevels;
  final SaveLevelProgress _saveProgress;
  List<GameLevelEntity> _levels = [];

  Future<void> _onLoad(
    TapMatchLoadRequested event,
    Emitter<TapMatchState> emit,
  ) async {
    emit(const TapMatchLoading());
    _levels = await _getLevels(event.gameType, zoneId: event.zoneId);
    if (_levels.isEmpty) {
      emit(const TapMatchError('No levels found'));
      return;
    }
    emit(_playingState(0));
  }

  Future<void> _onChoice(
    TapMatchChoiceMade event,
    Emitter<TapMatchState> emit,
  ) async {
    final current = state;
    if (current is! TapMatchPlaying) return;

    if (event.isCorrect) {
      await _saveProgress(
        levelId: current.level.id,
        starsEarned: 3,
        relatedConcepts: current.level.relatedConcepts,
        attempts: 1,
      );
      emit(TapMatchCompleted(
        level: current.level,
        levelIndex: current.levelIndex,
        totalLevels: current.totalLevels,
      ));
    }
  }

  void _onNext(TapMatchNextLevel event, Emitter<TapMatchState> emit) {
    final current = state;
    if (current is! TapMatchCompleted) return;
    final next = current.levelIndex + 1;
    if (next >= _levels.length) {
      emit(const TapMatchAllDone());
      return;
    }
    emit(_playingState(next));
  }

  TapMatchPlaying _playingState(int index) {
    final level = _levels[index];
    return TapMatchPlaying(
      level: level,
      levelIndex: index,
      totalLevels: _levels.length,
      prompt: level.lumiLineKey ?? 'Tap the correct one!',
      choices: LevelChoiceBuilder.buildChoices(level),
      target: LevelChoiceBuilder.targetDisplay(level),
    );
  }
}
