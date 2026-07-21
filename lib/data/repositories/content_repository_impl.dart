import 'package:toodler_kids/data/datasources/json_content_datasource.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl(this._dataSource);
  final JsonContentDataSource _dataSource;

  @override
  Future<ManifestEntity> loadManifest() => _dataSource.loadManifest();

  @override
  Future<List<GameLevelEntity>> getLevelsForGame(
    String gameType, {
    String? zoneId,
  }) =>
      _dataSource.loadLevelsForGameType(gameType, zoneId: zoneId);

  @override
  Future<GameLevelEntity?> getLevelById(String levelId) async {
    final manifest = await loadManifest();
    for (final zone in manifest.zones) {
      for (final gameType in zone.gameTypes) {
        final levels = await getLevelsForGame(gameType, zoneId: zone.id);
        for (final level in levels) {
          if (level.id == levelId) return level;
        }
      }
    }
    return null;
  }

  @override
  Future<List<DrawingTemplateEntity>> getDrawingTemplates() =>
      _dataSource.loadDrawingTemplates();

  @override
  Future<List<FunFactEntity>> getFunFacts() => _dataSource.loadFunFacts();

  @override
  Future<List<BadgeEntity>> getBadges() => _dataSource.loadBadges();

  @override
  Future<List<StickerAlbumEntity>> getStickerAlbums() =>
      _dataSource.loadStickerAlbums();

  @override
  Future<Map<String, String>> loadLocalization(String languageCode) =>
      _dataSource.loadLocalization(languageCode);
}
