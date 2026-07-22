import 'package:toodler_kids/data/datasources/local_progress_datasource.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._dataSource);
  final LocalProgressDataSource _dataSource;

  @override
  Future<ChildProfileEntity?> getProfile() => _dataSource.getProfile();

  @override
  Future<void> saveProfile(ChildProfileEntity profile) =>
      _dataSource.saveProfile(profile);

  @override
  Future<LevelProgressEntity?> getLevelProgress(String levelId) =>
      _dataSource.getLevelProgress(levelId);

  @override
  Future<void> saveLevelProgress(LevelProgressEntity progress) =>
      _dataSource.saveLevelProgress(progress);

  @override
  Future<Map<String, LevelProgressEntity>> getAllLevelProgress() =>
      _dataSource.getAllLevelProgress();

  @override
  Future<int> getTotalStars() => _dataSource.getTotalStars();

  @override
  Future<List<String>> getEarnedBadges() => _dataSource.getEarnedBadges();

  @override
  Future<void> unlockBadge(String badgeId) =>
      _dataSource.unlockBadge(badgeId);

  @override
  Future<Map<String, dynamic>> getDrawingSave(String templateId) =>
      _dataSource.getDrawingSave(templateId);

  @override
  Future<void> saveDrawing(String templateId, Map<String, dynamic> data) =>
      _dataSource.saveDrawing(templateId, data);

  @override
  Future<String?> getLastDrawingTemplateId() =>
      _dataSource.getLastDrawingTemplateId();

  @override
  Future<int?> getGameSessionLevelIndex(String sessionKey) =>
      _dataSource.getGameSessionLevelIndex(sessionKey);

  @override
  Future<void> saveGameSessionLevelIndex(
    String sessionKey,
    int levelIndex,
  ) =>
      _dataSource.saveGameSessionLevelIndex(sessionKey, levelIndex);
}
