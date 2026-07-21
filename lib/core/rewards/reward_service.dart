import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

class RewardService {
  RewardService(this._progressRepo);

  final ProgressRepository _progressRepo;

  Future<void> checkAndUnlockBadges({
    required String zoneId,
    required int levelsCompletedInZone,
  }) async {
    final earned = await _progressRepo.getEarnedBadges();

    final badgeRules = [
      ('animal_expert', 'jungle_grove', 10),
      ('number_wizard', 'number_mountain', 10),
      ('letter_hero', 'letter_lane', 10),
      ('dino_explorer', 'dinosaurs', 25),
    ];

    for (final (badgeId, zone, count) in badgeRules) {
      if (zoneId == zone &&
          levelsCompletedInZone >= count &&
          !earned.contains(badgeId)) {
        await _progressRepo.unlockBadge(badgeId);
      }
    }
  }

  int calculateStars({
    required int attempts,
    required int hintsUsed,
    required int cluesUsed,
  }) {
    if (attempts <= 1 && hintsUsed == 0 && cluesUsed <= 1) return 3;
    if (attempts <= 2 && hintsUsed <= 1) return 2;
    return 1;
  }

  bool shouldShowFunFact(int levelNumber) {
    return levelNumber % 3 == 0;
  }
}

class StickerProgress {
  StickerProgress({required this.albumId, required this.filledSlots});

  final String albumId;
  final int filledSlots;
}

Future<List<StickerProgress>> getStickerProgress(
  ProgressRepository repo,
  List<StickerAlbumEntity> albums,
) async {
  final allProgress = await repo.getAllLevelProgress();
  final completed = allProgress.values.where((p) => p.completed).length;

  return albums.map((album) {
    return StickerProgress(
      albumId: album.id,
      filledSlots: completed.clamp(0, album.slots),
    );
  }).toList();
}
