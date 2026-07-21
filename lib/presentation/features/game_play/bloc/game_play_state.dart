part of 'game_play_bloc.dart';

sealed class GamePlayState extends Equatable {
  const GamePlayState();
  @override
  List<Object?> get props => [];
}

class GamePlayInitial extends GamePlayState {
  const GamePlayInitial();
}

class GamePlayLoading extends GamePlayState {
  const GamePlayLoading();
}

class GamePlayError extends GamePlayState {
  const GamePlayError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class GamePlayPlaying extends GamePlayState {
  const GamePlayPlaying({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
    required this.mechanic,
    required this.prompt,
    required this.choices,
    required this.attempts,
    required this.hintsUsed,
    required this.placedItems,
    this.showHint = false,
    this.hintOptionId,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;
  final String mechanic;
  final String prompt;
  final List<Map<String, dynamic>> choices;
  final int attempts;
  final int hintsUsed;
  final List<Map<String, dynamic>> placedItems;
  final bool showHint;
  final String? hintOptionId;

  GamePlayPlaying copyWith({
    int? attempts,
    int? hintsUsed,
    bool? showHint,
    String? hintOptionId,
    List<Map<String, dynamic>>? placedItems,
  }) {
    return GamePlayPlaying(
      level: level,
      levelIndex: levelIndex,
      totalLevels: totalLevels,
      mechanic: mechanic,
      prompt: prompt,
      choices: choices,
      attempts: attempts ?? this.attempts,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      placedItems: placedItems ?? this.placedItems,
      showHint: showHint ?? this.showHint,
      hintOptionId: hintOptionId ?? this.hintOptionId,
    );
  }

  @override
  List<Object?> get props =>
      [level, levelIndex, mechanic, attempts, hintsUsed, placedItems, showHint];
}

class GamePlayCompleted extends GamePlayState {
  const GamePlayCompleted({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
    required this.starsEarned,
    required this.mechanic,
    this.funFactKey,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;
  final int starsEarned;
  final String mechanic;
  final String? funFactKey;

  @override
  List<Object?> get props => [level, starsEarned];
}

class GamePlayAllDone extends GamePlayState {
  const GamePlayAllDone();
}
