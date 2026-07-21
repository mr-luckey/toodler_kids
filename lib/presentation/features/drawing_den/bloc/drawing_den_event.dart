part of 'drawing_den_bloc.dart';

sealed class DrawingDenEvent extends Equatable {
  const DrawingDenEvent();
  @override
  List<Object?> get props => [];
}

class DrawingDenLoadRequested extends DrawingDenEvent {
  const DrawingDenLoadRequested();
}

class DrawingDenTemplateSelected extends DrawingDenEvent {
  const DrawingDenTemplateSelected(this.template);
  final DrawingTemplateEntity template;
  @override
  List<Object?> get props => [template];
}

class DrawingDenColorSelected extends DrawingDenEvent {
  const DrawingDenColorSelected(this.color);
  final Color color;
  @override
  List<Object?> get props => [color];
}

class DrawingDenRegionFilled extends DrawingDenEvent {
  const DrawingDenRegionFilled({required this.regionId, required this.color});
  final String regionId;
  final Color color;
  @override
  List<Object?> get props => [regionId, color];
}

class DrawingDenStrokeAdded extends DrawingDenEvent {
  const DrawingDenStrokeAdded(this.stroke);
  final SmoothStroke stroke;
  @override
  List<Object?> get props => [stroke];
}

class DrawingDenUndo extends DrawingDenEvent {
  const DrawingDenUndo();
}

class DrawingDenClear extends DrawingDenEvent {
  const DrawingDenClear();
}

class DrawingDenSave extends DrawingDenEvent {
  const DrawingDenSave();
}

class DrawingDenModeChanged extends DrawingDenEvent {
  const DrawingDenModeChanged(this.mode);
  final DrawingMode mode;
  @override
  List<Object?> get props => [mode];
}
