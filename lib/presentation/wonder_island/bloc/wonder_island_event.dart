part of 'wonder_island_bloc.dart';

sealed class WonderIslandEvent extends Equatable {
  const WonderIslandEvent();
  @override
  List<Object?> get props => [];
}

class WonderIslandLoadRequested extends WonderIslandEvent {
  const WonderIslandLoadRequested();
}
