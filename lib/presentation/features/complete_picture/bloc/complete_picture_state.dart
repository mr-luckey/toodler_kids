part of 'complete_picture_bloc.dart';

sealed class CompletePictureState extends Equatable {
  const CompletePictureState();
  @override
  List<Object?> get props => [];
}

class CompletePictureInitial extends CompletePictureState {
  const CompletePictureInitial();
}

class CompletePictureLoading extends CompletePictureState {
  const CompletePictureLoading();
}

class CompletePictureError extends CompletePictureState {
  const CompletePictureError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class CompletePicturePlaying extends CompletePictureState {
  const CompletePicturePlaying({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
    required this.attempts,
    required this.hintsUsed,
    this.showHint = false,
    this.hintOptionId,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;
  final int attempts;
  final int hintsUsed;
  final bool showHint;
  final String? hintOptionId;

  CompletePicturePlaying copyWith({
    int? attempts,
    int? hintsUsed,
    bool? showHint,
    String? hintOptionId,
  }) {
    return CompletePicturePlaying(
      level: level,
      levelIndex: levelIndex,
      totalLevels: totalLevels,
      attempts: attempts ?? this.attempts,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      showHint: showHint ?? this.showHint,
      hintOptionId: hintOptionId ?? this.hintOptionId,
    );
  }

  @override
  List<Object?> get props => [level, levelIndex, attempts, hintsUsed, showHint];
}

class CompletePictureCompleted extends CompletePictureState {
  const CompletePictureCompleted({
    required this.level,
    required this.levelIndex,
    required this.totalLevels,
    required this.starsEarned,
    this.showFunFact = false,
    this.funFactKey,
  });

  final GameLevelEntity level;
  final int levelIndex;
  final int totalLevels;
  final int starsEarned;
  final bool showFunFact;
  final String? funFactKey;

  @override
  List<Object?> get props => [level, starsEarned];
}

class CompletePictureAllDone extends CompletePictureState {
  const CompletePictureAllDone();
}
