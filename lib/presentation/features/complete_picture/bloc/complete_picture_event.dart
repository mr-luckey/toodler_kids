part of 'complete_picture_bloc.dart';

sealed class CompletePictureEvent extends Equatable {
  const CompletePictureEvent();
  @override
  List<Object?> get props => [];
}

class CompletePictureLoadRequested extends CompletePictureEvent {
  const CompletePictureLoadRequested();
}

class CompletePicturePieceSelected extends CompletePictureEvent {
  const CompletePicturePieceSelected({required this.isCorrect});
  final bool isCorrect;
  @override
  List<Object?> get props => [isCorrect];
}

class CompletePictureNextLevel extends CompletePictureEvent {
  const CompletePictureNextLevel();
}

class CompletePictureDismissCelebration extends CompletePictureEvent {
  const CompletePictureDismissCelebration();
}
