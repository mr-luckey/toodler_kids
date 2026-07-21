import 'package:flutter_bloc/flutter_bloc.dart';

/// Premium feature gate — Phase 3 billing integration point.
class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(const PremiumState(isPremium: false));

  void unlockPremium() => emit(const PremiumState(isPremium: true));

  bool canAccessZone(String zoneId, {required bool isFree}) {
    if (isFree || state.isPremium) return true;
    return _freeZoneIds.contains(zoneId);
  }

  bool canAccessDrawingTemplate(bool templateIsFree) {
    return templateIsFree || state.isPremium;
  }

  static const _freeZoneIds = {
    'jungle_grove',
    'number_mountain',
    'letter_lane',
    'dinosaurs',
    'drawing_den',
  };
}

class PremiumState {
  const PremiumState({required this.isPremium});
  final bool isPremium;
}

/// Free tier content per plan Section 33.
class FreeTierConfig {
  static const freeDrawingCount = 50;
  static const freeCompletePictureCount = 25;
  static const freeDinoLevels = 50;
  static const freeStoryCount = 10;
  static const freeNumberLevels = 100;
}
