import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';

part 'wonder_island_event.dart';
part 'wonder_island_state.dart';

class WonderIslandBloc extends Bloc<WonderIslandEvent, WonderIslandState> {
  WonderIslandBloc(
    this._loadManifest,
    this._getZones,
    this._progressRepo,
  ) : super(const WonderIslandInitial()) {
    on<WonderIslandLoadRequested>(_onLoad);
  }

  final LoadManifest _loadManifest;
  final GetZones _getZones;
  final ProgressRepository _progressRepo;

  Future<void> _onLoad(
    WonderIslandLoadRequested event,
    Emitter<WonderIslandState> emit,
  ) async {
    emit(const WonderIslandLoading());
    try {
      final manifest = await _loadManifest();
      final zones = await _getZones();
      final profile = await _progressRepo.getProfile();
      final totalStars = await _progressRepo.getTotalStars();
      emit(WonderIslandLoaded(
        manifest: manifest,
        zones: zones,
        profile: profile,
        totalStars: totalStars,
      ));
    } catch (e) {
      emit(WonderIslandError(e.toString()));
    }
  }
}
