part of 'drawing_den_bloc.dart';

sealed class DrawingDenState extends Equatable {
  const DrawingDenState();
  @override
  List<Object?> get props => [];
}

class DrawingDenInitial extends DrawingDenState {
  const DrawingDenInitial();
}

class DrawingDenLoading extends DrawingDenState {
  const DrawingDenLoading();
}

class DrawingDenLoaded extends DrawingDenState {
  const DrawingDenLoaded({
    required this.templates,
    required this.selectedColor,
    required this.mode,
    required this.regionColors,
    required this.strokes,
    required this.colorStrokes,
    required this.undoStack,
    this.selectedTemplate,
    this.strokeWidth = 8.0,
    this.colorStrokeWidth = 18.0,
  });

  final List<DrawingTemplateEntity> templates;
  final DrawingTemplateEntity? selectedTemplate;
  final Color selectedColor;
  final DrawingMode mode;
  final Map<String, Color> regionColors;
  final List<SmoothStroke> strokes;
  final List<SmoothStroke> colorStrokes;
  final List<DrawingUndoEntry> undoStack;
  final double strokeWidth;
  final double colorStrokeWidth;

  DrawingDenLoaded copyWith({
    List<DrawingTemplateEntity>? templates,
    DrawingTemplateEntity? selectedTemplate,
    Color? selectedColor,
    DrawingMode? mode,
    Map<String, Color>? regionColors,
    List<SmoothStroke>? strokes,
    List<SmoothStroke>? colorStrokes,
    List<DrawingUndoEntry>? undoStack,
    double? strokeWidth,
    double? colorStrokeWidth,
  }) {
    return DrawingDenLoaded(
      templates: templates ?? this.templates,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedColor: selectedColor ?? this.selectedColor,
      mode: mode ?? this.mode,
      regionColors: regionColors ?? this.regionColors,
      strokes: strokes ?? this.strokes,
      colorStrokes: colorStrokes ?? this.colorStrokes,
      undoStack: undoStack ?? this.undoStack,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      colorStrokeWidth: colorStrokeWidth ?? this.colorStrokeWidth,
    );
  }

  List<ColorFillRegion> get fillRegions {
    if (selectedTemplate == null) return [];
    return selectedTemplate!.fillRegions.map((r) {
      return ColorFillRegion(
        id: r['id'] as String,
        pathData: r['path'] as String,
        defaultColor: Colors.white,
      );
    }).toList();
  }

  @override
  List<Object?> get props =>
      [selectedTemplate, selectedColor, mode, regionColors, strokes, colorStrokes];
}
