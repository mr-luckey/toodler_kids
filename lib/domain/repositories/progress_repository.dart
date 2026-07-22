import 'package:toodler_kids/domain/entities/entities.dart';

abstract class ProgressRepository {
  Future<ChildProfileEntity?> getProfile();
  Future<void> saveProfile(ChildProfileEntity profile);
  Future<LevelProgressEntity?> getLevelProgress(String levelId);
  Future<void> saveLevelProgress(LevelProgressEntity progress);
  Future<Map<String, LevelProgressEntity>> getAllLevelProgress();
  Future<int> getTotalStars();
  Future<List<String>> getEarnedBadges();
  Future<void> unlockBadge(String badgeId);
  Future<Map<String, dynamic>> getDrawingSave(String templateId);
  Future<void> saveDrawing(String templateId, Map<String, dynamic> data);
  Future<String?> getLastDrawingTemplateId();
  Future<int?> getGameSessionLevelIndex(String sessionKey);
  Future<void> saveGameSessionLevelIndex(String sessionKey, int levelIndex);
}
