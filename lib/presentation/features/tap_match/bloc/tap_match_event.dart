part of 'tap_match_bloc.dart';

sealed class TapMatchEvent extends Equatable {
  const TapMatchEvent();
  @override
  List<Object?> get props => [];
}

class TapMatchLoadRequested extends TapMatchEvent {
  const TapMatchLoadRequested({required this.gameType, this.zoneId});
  final String gameType;
  final String? zoneId;
  @override
  List<Object?> get props => [gameType, zoneId];
}

class TapMatchChoiceMade extends TapMatchEvent {
  const TapMatchChoiceMade({required this.isCorrect});
  final bool isCorrect;
  @override
  List<Object?> get props => [isCorrect];
}

class TapMatchNextLevel extends TapMatchEvent {
  const TapMatchNextLevel();
}
