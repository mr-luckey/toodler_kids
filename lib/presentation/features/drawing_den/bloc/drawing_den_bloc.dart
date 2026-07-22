import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';
import 'package:toodler_kids/core/progress/drawing_progress_codec.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';

part 'drawing_den_event.dart';
part 'drawing_den_state.dart';

class DrawingDenBloc extends Bloc<DrawingDenEvent, DrawingDenState> {
  DrawingDenBloc(this._getTemplates, this._progressRepo, this._sounds)
      : super(const DrawingDenInitial()) {
    on<DrawingDenLoadRequested>(_onLoad);
    on<DrawingDenTemplateSelected>(_onSelect);
    on<DrawingDenColorSelected>(_onColor);
    on<DrawingDenRegionFilled>(_onFill);
    on<DrawingDenStrokeAdded>(_onStroke);
    on<DrawingDenUndo>(_onUndo);
    on<DrawingDenClear>(_onClear);
    on<DrawingDenSave>(_onSave);
    on<DrawingDenModeChanged>(_onMode);
  }

  final GetDrawingTemplates _getTemplates;
  final ProgressRepository _progressRepo;
  final SoundManager _sounds;

  Future<void> _onLoad(
    DrawingDenLoadRequested event,
    Emitter<DrawingDenState> emit,
  ) async {
    emit(const DrawingDenLoading());
    final templates = await _getTemplates();
    final lastTemplateId = await _progressRepo.getLastDrawingTemplateId();
    DrawingTemplateEntity? selected;
    if (lastTemplateId != null) {
      for (final template in templates) {
        if (template.id == lastTemplateId) {
          selected = template;
          break;
        }
      }
    }
    selected ??= templates.isNotEmpty ? templates.first : null;
    final restored = selected == null
        ? _emptyArtwork()
        : await _loadArtwork(selected.id);

    emit(DrawingDenLoaded(
      templates: templates,
      selectedTemplate: selected,
      selectedColor: restored.selectedColor,
      mode: restored.mode,
      regionColors: restored.regionColors,
      strokes: restored.strokes,
      colorStrokes: restored.colorStrokes,
      undoStack: [],
    ));
  }

  Future<void> _onSelect(
    DrawingDenTemplateSelected event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    await _persistDrawing(current);
    final restored = await _loadArtwork(event.template.id);
    emit(current.copyWith(
      selectedTemplate: event.template,
      selectedColor: restored.selectedColor,
      mode: restored.mode,
      regionColors: restored.regionColors,
      strokes: restored.strokes,
      colorStrokes: restored.colorStrokes,
      undoStack: [],
    ));
  }

  Future<void> _onColor(
    DrawingDenColorSelected event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final next = current.copyWith(selectedColor: event.color);
    emit(next);
    await _persistDrawing(next);
  }

  void _onFill(DrawingDenRegionFilled event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final colors = Map<String, Color>.from(current.regionColors);
    final previous = colors[event.regionId];
    if (previous == event.color) return;
    colors[event.regionId] = event.color;
    _sounds.playSfx('color_fill');
    final next = current.copyWith(
      regionColors: colors,
      undoStack: [
        ...current.undoStack,
        DrawingUndoEntry.fill(
          regionId: event.regionId,
          previousColor: previous,
        ),
      ],
    );
    emit(next);
    _persistDrawing(next);
  }

  Future<void> _onStroke(
    DrawingDenStrokeAdded event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    DrawingDenLoaded next;
    if (current.mode == DrawingMode.colorFill) {
      final colorStrokes = [...current.colorStrokes, event.stroke];
      _sounds.playSfx('color_fill');
      next = current.copyWith(
        colorStrokes: colorStrokes,
        undoStack: [...current.undoStack, const DrawingUndoEntry.colorStroke()],
      );
    } else {
      next = current.copyWith(
        strokes: [...current.strokes, event.stroke],
        undoStack: [...current.undoStack, const DrawingUndoEntry.stroke()],
      );
    }
    emit(next);
    await _persistDrawing(next);
  }

  Future<void> _onUndo(
    DrawingDenUndo event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded || current.undoStack.isEmpty) return;
    final undo = [...current.undoStack]..removeLast();
    final last = current.undoStack.last;
    DrawingDenLoaded? next;

    if (last.type == DrawingUndoAction.stroke) {
      if (current.strokes.isEmpty) return;
      final strokes = [...current.strokes]..removeLast();
      next = current.copyWith(strokes: strokes, undoStack: undo);
    } else if (last.type == DrawingUndoAction.colorStroke) {
      if (current.colorStrokes.isEmpty) return;
      final colorStrokes = [...current.colorStrokes]..removeLast();
      next = current.copyWith(colorStrokes: colorStrokes, undoStack: undo);
    } else if (last.type == DrawingUndoAction.fill && last.regionId != null) {
      final colors = Map<String, Color>.from(current.regionColors);
      if (last.previousColor == null) {
        colors.remove(last.regionId);
      } else {
        colors[last.regionId!] = last.previousColor!;
      }
      next = current.copyWith(regionColors: colors, undoStack: undo);
    }

    if (next == null) return;
    emit(next);
    await _persistDrawing(next);
  }

  Future<void> _onClear(
    DrawingDenClear event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final next = current.copyWith(
      strokes: [],
      colorStrokes: [],
      regionColors: {},
      undoStack: [],
    );
    emit(next);
    await _persistDrawing(next);
  }

  Future<void> _onSave(
    DrawingDenSave event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is DrawingDenLoaded) {
      await _persistDrawing(current);
    }
  }

  Future<void> _onMode(
    DrawingDenModeChanged event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final next = current.copyWith(mode: event.mode);
    emit(next);
    await _persistDrawing(next);
  }

  Future<void> _persistDrawing(DrawingDenLoaded state) async {
    final template = state.selectedTemplate;
    if (template == null) return;
    await _progressRepo.saveDrawing(
      template.id,
      DrawingProgressCodec.encode(
        mode: state.mode.name,
        selectedColor: state.selectedColor,
        colorStrokes: state.colorStrokes,
        strokes: state.strokes,
        regionColors: state.regionColors,
      ),
    );
  }

  Future<({
    List<SmoothStroke> colorStrokes,
    List<SmoothStroke> strokes,
    Map<String, Color> regionColors,
    DrawingMode mode,
    Color selectedColor,
  })> _loadArtwork(String templateId) async {
    final saved = await _progressRepo.getDrawingSave(templateId);
    if (saved.isEmpty) return _emptyArtwork();
    return (
      colorStrokes: DrawingProgressCodec.decodeStrokes(saved['colorStrokes']),
      strokes: DrawingProgressCodec.decodeStrokes(saved['strokes']),
      regionColors: DrawingProgressCodec.decodeRegionColors(saved['regionColors']),
      mode: _modeFromName(DrawingProgressCodec.decodeModeName(saved['mode'])) ??
          DrawingMode.colorFill,
      selectedColor:
          DrawingProgressCodec.decodeColor(saved['selectedColor']) ??
              const Color(0xFFFF5252),
    );
  }

  ({
    List<SmoothStroke> colorStrokes,
    List<SmoothStroke> strokes,
    Map<String, Color> regionColors,
    DrawingMode mode,
    Color selectedColor,
  }) _emptyArtwork() => (
        colorStrokes: <SmoothStroke>[],
        strokes: <SmoothStroke>[],
        regionColors: <String, Color>{},
        mode: DrawingMode.colorFill,
        selectedColor: const Color(0xFFFF5252),
      );

  DrawingMode? _modeFromName(String? name) {
    if (name == null) return null;
    for (final mode in DrawingMode.values) {
      if (mode.name == name) return mode;
    }
    return null;
  }
}

enum DrawingMode { colorFill, freeDraw }

enum DrawingUndoAction { stroke, colorStroke, fill }

class DrawingUndoEntry {
  const DrawingUndoEntry.stroke()
      : type = DrawingUndoAction.stroke,
        regionId = null,
        previousColor = null;
  const DrawingUndoEntry.colorStroke()
      : type = DrawingUndoAction.colorStroke,
        regionId = null,
        previousColor = null;
  const DrawingUndoEntry.fill({required this.regionId, this.previousColor})
      : type = DrawingUndoAction.fill;

  final DrawingUndoAction type;
  final String? regionId;
  final Color? previousColor;
}
