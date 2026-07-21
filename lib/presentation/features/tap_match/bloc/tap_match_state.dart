part of 'tap_match_bloc.dart';

sealed class TapMatchState extends Equatable {
  const TapMatchState();
  @override
  List<Object?> get props => [];
}

class TapMatchInitial extends TapMatchState {
  const TapMatchInitial();
}

class TapMatchLoading extends TapMatchState {
  const TapMatchLoading();
}

class TapMatchError extends TapMatchState {
  const TapMatchError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class TapMatchPlaying extends TapMatchState {
  const TapMatchPlaying({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
    required this.prompt,
    required this.choices,
    this.target,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;
  final String prompt;
  final List<Map<String, dynamic>> choices;
  final Map<String, dynamic>? target;

  @override
  List<Object?> get props => [level, levelIndex, prompt, target];
}

class TapMatchCompleted extends TapMatchState {
  const TapMatchCompleted({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;

  @override
  List<Object?> get props => [level, levelIndex];
}

class TapMatchAllDone extends TapMatchState {
  const TapMatchAllDone();
}
