import 'package:toodler_kids/domain/entities/entities.dart';

abstract class ContentRepository {
  Future<ManifestEntity> loadManifest();
  Future<List<GameLevelEntity>> getLevelsForGame(String gameType, {String? zoneId});
  Future<GameLevelEntity?> getLevelById(String levelId);
  Future<List<DrawingTemplateEntity>> getDrawingTemplates();
  Future<List<FunFactEntity>> getFunFacts();
  Future<List<BadgeEntity>> getBadges();
  Future<List<StickerAlbumEntity>> getStickerAlbums();
  Future<Map<String, String>> loadLocalization(String languageCode);
}
