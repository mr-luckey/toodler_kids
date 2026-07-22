import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

class GameResumeHelper {
  GameResumeHelper(this._progressRepo);
  final ProgressRepository _progressRepo;

  static String sessionKey({
    required String gameType,
    String? zoneId,
  }) =>
      zoneId == null ? gameType : '$gameType::$zoneId';

  Future<int> resolveStartIndex({
    required String sessionKey,
    required List<GameLevelEntity> levels,
  }) async {
    if (levels.isEmpty) return 0;

    var firstIncomplete = levels.length - 1;
    for (var i = 0; i < levels.length; i++) {
      final progress = await _progressRepo.getLevelProgress(levels[i].id);
      if (progress?.completed != true) {
        firstIncomplete = i;
        break;
      }
    }

    final saved = await _progressRepo.getGameSessionLevelIndex(sessionKey);
    if (saved != null && saved >= 0 && saved < levels.length) {
      final savedProgress = await _progressRepo.getLevelProgress(levels[saved].id);
      if (savedProgress?.completed != true) {
        return saved;
      }
    }

    return firstIncomplete.clamp(0, levels.length - 1);
  }

  Future<void> rememberLevel(String sessionKey, int index) =>
      _progressRepo.saveGameSessionLevelIndex(sessionKey, index);
}
