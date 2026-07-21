import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/data/models/content_models.dart';
import 'package:toodler_kids/domain/entities/entities.dart';

class JsonContentDataSource {
  ManifestEntity? _cachedManifest;
  final Map<String, List<GameLevelEntity>> _levelCache = {};
  final Map<String, Map<String, String>> _localizationCache = {};

  Future<ManifestEntity> loadManifest() async {
    if (_cachedManifest != null) return _cachedManifest!;
    final jsonStr =
        await rootBundle.loadString(AppConstants.manifestPath);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _cachedManifest = ManifestModel.fromJson(json).toEntity();
    return _cachedManifest!;
  }

  Future<List<GameLevelEntity>> loadLevelsFromPath(String path) async {
    if (_levelCache.containsKey(path)) return _levelCache[path]!;
    try {
      final jsonStr = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonStr);
      final List<dynamic> levelsList;
      if (decoded is List) {
        levelsList = decoded;
      } else if (decoded is Map && decoded['levels'] != null) {
        levelsList = decoded['levels'] as List<dynamic>;
      } else {
        levelsList = [];
      }
      final levels = levelsList
          .map((l) => LevelModel.fromJson(l as Map<String, dynamic>).toEntity())
          .toList();
      _levelCache[path] = levels;
      return levels;
    } catch (_) {
      return [];
    }
  }

  Future<List<GameLevelEntity>> loadLevelsForGameType(
    String gameType, {
    String? zoneId,
  }) async {
    final cacheKey = '$gameType${zoneId ?? ''}';
    if (_levelCache.containsKey(cacheKey)) return _levelCache[cacheKey]!;

    final manifest = await loadManifest();
    final registry = manifest.gameTypeRegistry[gameType];
    final paths = (registry?['contentPaths'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        _defaultPathsForGameType(gameType);

    final allLevels = <GameLevelEntity>[];
    for (final path in paths) {
      allLevels.addAll(await loadLevelsFromPath(path));
    }

    if (zoneId != null) {
      final filtered =
          allLevels.where((l) => l.zoneId == zoneId).toList();
      _levelCache[cacheKey] = filtered;
      return filtered;
    }

    _levelCache[cacheKey] = allLevels;
    return allLevels;
  }

  List<String> _defaultPathsForGameType(String gameType) {
    // Fallback paths when manifest registry is unavailable
    const paths = {
      'complete_picture': [
        'assets/content/games/complete_picture/levels_001_100.json',
      ],
      'animal_world': ['assets/content/learning/animals/animal_world.json'],
      'animal_names': ['assets/content/learning/animals/animal_names.json'],
      'number_recognition': ['assets/content/learning/math/number_recognition.json'],
      'counting': ['assets/content/learning/math/counting.json'],
      'letter_recognition': ['assets/content/learning/alphabet/letter_recognition.json'],
      'letter_phonics': ['assets/content/learning/alphabet/letter_phonics.json'],
      'dino_names': ['assets/content/learning/animals/dino_names.json'],
      'space_objects': ['assets/content/learning/animals/space_objects.json'],
      'sports_names': ['assets/content/learning/animals/sports_names.json'],
      'four_seasons': ['assets/content/learning/animals/four_seasons.json'],
      'household_items': ['assets/content/learning/animals/household_items.json'],
      'fun_colors': ['assets/content/learning/colors/fun_colors.json'],
      'color_recognition': ['assets/content/learning/colors/color_recognition.json'],
      'opposites': ['assets/content/learning/colors/opposites.json'],
      'shadow_game': ['assets/content/games/shadow_game/levels.json'],
      'what_am_i': ['assets/content/games/what_am_i/riddles.json'],
      'build_scene': ['assets/content/games/build_scene/scenes.json'],
      'which_tool_works': ['assets/content/games/tools/which_tool_works.json'],
      'true_false_animals': ['assets/content/learning/true_false/true_false_animals.json'],
      'true_false_dino': ['assets/content/learning/true_false/true_false_dino.json'],
      'true_false_space': ['assets/content/learning/true_false/true_false_space.json'],
    };
    return paths[gameType] ?? [];
  }

  Future<List<DrawingTemplateEntity>> loadDrawingTemplates() async {
    const path = 'assets/content/games/drawing_den/templates.json';
    try {
      final jsonStr = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonStr);
      final templates = decoded is Map
          ? decoded['templates'] as List<dynamic>? ?? []
          : decoded as List<dynamic>;
      return templates
          .map((t) =>
              DrawingTemplateModel.fromJson(t as Map<String, dynamic>).toEntity())
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<FunFactEntity>> loadFunFacts() async {
    const path = 'assets/content/fun_facts/facts.json';
    try {
      final jsonStr = await rootBundle.loadString(path);
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((f) {
        final m = f as Map<String, dynamic>;
        return FunFactEntity(
          id: m['id'] as String,
          factKey: m['factKey'] as String,
          category: m['category'] as String? ?? 'general',
          ageMin: m['ageMin'] as int? ?? 3,
          relatedConcepts: (m['relatedConcepts'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              [],
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<BadgeEntity>> loadBadges() async {
    const path = 'assets/content/rewards/badges.json';
    try {
      final jsonStr = await rootBundle.loadString(path);
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((b) {
        final m = b as Map<String, dynamic>;
        return BadgeEntity(
          id: m['id'] as String,
          nameKey: m['nameKey'] as String,
          descriptionKey: m['descriptionKey'] as String,
          icon: m['icon'] as String? ?? 'star',
          unlockRule: Map<String, dynamic>.from(m['unlockRule'] as Map? ?? {}),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<StickerAlbumEntity>> loadStickerAlbums() async {
    const path = 'assets/content/rewards/stickers.json';
    try {
      final jsonStr = await rootBundle.loadString(path);
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((s) {
        final m = s as Map<String, dynamic>;
        return StickerAlbumEntity(
          id: m['id'] as String,
          nameKey: m['nameKey'] as String,
          icon: m['icon'] as String? ?? 'album',
          slots: m['slots'] as int? ?? 50,
          unlockRule: Map<String, dynamic>.from(m['unlockRule'] as Map? ?? {}),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, String>> loadLocalization(String languageCode) async {
    if (_localizationCache.containsKey(languageCode)) {
      return _localizationCache[languageCode]!;
    }
    final path = languageCode == 'ur'
        ? AppConstants.localizationUrPath
        : AppConstants.localizationEnPath;
    try {
      final jsonStr = await rootBundle.loadString(path);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final strings = map.map((k, v) => MapEntry(k, v.toString()));
      _localizationCache[languageCode] = strings;
      return strings;
    } catch (_) {
      return {};
    }
  }
}
