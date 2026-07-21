import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
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
    emit(DrawingDenLoaded(
      templates: templates,
      selectedTemplate: templates.isNotEmpty ? templates.first : null,
      selectedColor: const Color(0xFFFF5252),
      mode: DrawingMode.colorFill,
      regionColors: {},
      strokes: [],
      undoStack: [],
    ));
  }

  Future<void> _onSelect(
    DrawingDenTemplateSelected event,
    Emitter<DrawingDenState> emit,
  ) async {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final saved = await _progressRepo.getDrawingSave(event.template.id);
    final regionColors = <String, Color>{};
    if (saved['regionColors'] != null) {
      (saved['regionColors'] as Map).forEach((k, v) {
        regionColors[k.toString()] = Color(int.parse(v.toString()));
      });
    }
    emit(current.copyWith(
      selectedTemplate: event.template,
      regionColors: regionColors,
      strokes: [],
    ));
  }

  void _onColor(DrawingDenColorSelected event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is DrawingDenLoaded) {
      emit(current.copyWith(selectedColor: event.color));
    }
  }

  void _onFill(DrawingDenRegionFilled event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final colors = Map<String, Color>.from(current.regionColors);
    colors[event.regionId] = event.color;
    _sounds.playSfx('color_fill');
    emit(current.copyWith(regionColors: colors));
  }

  void _onStroke(DrawingDenStrokeAdded event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is! DrawingDenLoaded) return;
    final strokes = [...current.strokes, event.stroke];
    final undo = [...current.undoStack, DrawingUndoAction.stroke];
    emit(current.copyWith(strokes: strokes, undoStack: undo));
  }

  void _onUndo(DrawingDenUndo event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is! DrawingDenLoaded || current.strokes.isEmpty) return;
    final strokes = [...current.strokes]..removeLast();
    emit(current.copyWith(strokes: strokes));
  }

  void _onClear(DrawingDenClear event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is DrawingDenLoaded) {
      emit(current.copyWith(strokes: [], regionColors: {}));
    }
  }

  Future<void> _onSave(DrawingDenSave event, Emitter<DrawingDenState> emit) async {
    final current = state;
    if (current is! DrawingDenLoaded || current.selectedTemplate == null) return;
    final colorMap = current.regionColors.map(
      (k, v) => MapEntry(k, v.toARGB32().toString()),
    );
    await _progressRepo.saveDrawing(current.selectedTemplate!.id, {
      'regionColors': colorMap,
      'strokeCount': current.strokes.length,
    });
  }

  void _onMode(DrawingDenModeChanged event, Emitter<DrawingDenState> emit) {
    final current = state;
    if (current is DrawingDenLoaded) {
      emit(current.copyWith(mode: event.mode));
    }
  }
}

enum DrawingMode { colorFill, freeDraw }

enum DrawingUndoAction { stroke, fill }
