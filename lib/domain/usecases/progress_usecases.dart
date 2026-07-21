import 'package:toodler_kids/core/adaptive/adaptive_engine.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

class SaveLevelProgress {
  SaveLevelProgress(this._progressRepo, this._adaptiveEngine);
  final ProgressRepository _progressRepo;
  final AdaptiveEngine _adaptiveEngine;

  Future<LevelProgressEntity> call({
    required String levelId,
    required int starsEarned,
    required List<String> relatedConcepts,
    required int attempts,
    int? timeMs,
  }) async {
    final existing = await _progressRepo.getLevelProgress(levelId);
    final progress = LevelProgressEntity(
      levelId: levelId,
      starsEarned: starsEarned > (existing?.starsEarned ?? 0)
          ? starsEarned
          : (existing?.starsEarned ?? starsEarned),
      completed: true,
      attempts: (existing?.attempts ?? 0) + attempts,
      lastPlayedAt: DateTime.now(),
      bestTimeMs: timeMs != null
          ? (existing?.bestTimeMs == null || timeMs < existing!.bestTimeMs!
              ? timeMs
              : existing.bestTimeMs)
          : existing?.bestTimeMs,
    );

    await _progressRepo.saveLevelProgress(progress);

    for (final concept in relatedConcepts) {
      await _adaptiveEngine.recordAttempt(
        concept: concept,
        success: starsEarned > 0,
        stars: starsEarned,
      );
    }

    final profile = await _progressRepo.getProfile();
    if (profile != null) {
      await _progressRepo.saveProfile(
        profile.copyWith(
          totalStars: await _progressRepo.getTotalStars(),
        ),
      );
    }

    return progress;
  }
}

class GetChildProfile {
  GetChildProfile(this._repository);
  final ProgressRepository _repository;

  Future<ChildProfileEntity?> call() => _repository.getProfile();
}

class SaveChildProfile {
  SaveChildProfile(this._repository);
  final ProgressRepository _repository;

  Future<void> call(ChildProfileEntity profile) =>
      _repository.saveProfile(profile);
}
