part of 'game_play_bloc.dart';

sealed class GamePlayEvent extends Equatable {
  const GamePlayEvent();
  @override
  List<Object?> get props => [];
}

class GamePlayLoadRequested extends GamePlayEvent {
  const GamePlayLoadRequested({required this.gameType, this.zoneId});
  final String gameType;
  final String? zoneId;
  @override
  List<Object?> get props => [gameType, zoneId];
}

class GamePlayAnswerSubmitted extends GamePlayEvent {
  const GamePlayAnswerSubmitted({required this.isCorrect, this.choiceId});
  final bool isCorrect;
  final String? choiceId;
  @override
  List<Object?> get props => [isCorrect, choiceId];
}

class GamePlayItemPlaced extends GamePlayEvent {
  const GamePlayItemPlaced(this.item);
  final Map<String, dynamic> item;
  @override
  List<Object?> get props => [item];
}

class GamePlayNextLevel extends GamePlayEvent {
  const GamePlayNextLevel();
}

class GamePlayDismissCelebration extends GamePlayEvent {
  const GamePlayDismissCelebration();
}
