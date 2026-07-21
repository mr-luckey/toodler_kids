import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/adaptive/adaptive_engine.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

part 'parent_dashboard_event.dart';
part 'parent_dashboard_state.dart';

class ParentDashboardBloc extends Bloc<ParentDashboardEvent, ParentDashboardState> {
  ParentDashboardBloc(this._progressRepo, this._adaptiveEngine)
      : super(const ParentDashboardInitial()) {
    on<ParentDashboardLoadRequested>(_onLoad);
  }

  final ProgressRepository _progressRepo;
  final AdaptiveEngine _adaptiveEngine;

  Future<void> _onLoad(
    ParentDashboardLoadRequested event,
    Emitter<ParentDashboardState> emit,
  ) async {
    emit(const ParentDashboardLoading());
    final profile = await _progressRepo.getProfile();
    final totalStars = await _progressRepo.getTotalStars();
    final badges = await _progressRepo.getEarnedBadges();
    final allProgress = await _progressRepo.getAllLevelProgress();
    final learningMap = _adaptiveEngine.getLearningMap();
    final recommended = _adaptiveEngine.getRecommendedConcepts();

    emit(ParentDashboardLoaded(
      profile: profile,
      totalStars: totalStars,
      earnedBadges: badges,
      levelsCompleted: allProgress.values.where((p) => p.completed).length,
      totalTimeMinutes: allProgress.length * 3,
      learningMap: learningMap,
      recommendedConcepts: recommended,
    ));
  }
}
