part of 'parent_dashboard_bloc.dart';

sealed class ParentDashboardEvent extends Equatable {
  const ParentDashboardEvent();
  @override
  List<Object?> get props => [];
}

class ParentDashboardLoadRequested extends ParentDashboardEvent {
  const ParentDashboardLoadRequested();
}
