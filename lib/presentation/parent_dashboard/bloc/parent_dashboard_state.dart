part of 'parent_dashboard_bloc.dart';

sealed class ParentDashboardState extends Equatable {
  const ParentDashboardState();
  @override
  List<Object?> get props => [];
}

class ParentDashboardInitial extends ParentDashboardState {
  const ParentDashboardInitial();
}

class ParentDashboardLoading extends ParentDashboardState {
  const ParentDashboardLoading();
}

class ParentDashboardLoaded extends ParentDashboardState {
  const ParentDashboardLoaded({
    required this.totalStars,
    required this.earnedBadges,
    required this.levelsCompleted,
    required this.totalTimeMinutes,
    required this.learningMap,
    required this.recommendedConcepts,
    this.profile,
  });

  final ChildProfileEntity? profile;
  final int totalStars;
  final List<String> earnedBadges;
  final int levelsCompleted;
  final int totalTimeMinutes;
  final List<LearningMapEntry> learningMap;
  final List<String> recommendedConcepts;

  @override
  List<Object?> get props =>
      [profile, totalStars, earnedBadges, levelsCompleted, learningMap];
}
