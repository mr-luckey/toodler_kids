part of 'wonder_island_bloc.dart';

sealed class WonderIslandState extends Equatable {
  const WonderIslandState();
  @override
  List<Object?> get props => [];
}

class WonderIslandInitial extends WonderIslandState {
  const WonderIslandInitial();
}

class WonderIslandLoading extends WonderIslandState {
  const WonderIslandLoading();
}

class WonderIslandLoaded extends WonderIslandState {
  const WonderIslandLoaded({
    required this.manifest,
    required this.zones,
    required this.totalStars,
    this.profile,
  });

  final ManifestEntity manifest;
  final List<ZoneEntity> zones;
  final ChildProfileEntity? profile;
  final int totalStars;

  @override
  List<Object?> get props => [manifest, zones, totalStars, profile];
}

class WonderIslandError extends WonderIslandState {
  const WonderIslandError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
