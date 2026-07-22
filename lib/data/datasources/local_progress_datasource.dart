import 'package:hive_flutter/hive_flutter.dart';
import 'package:toodler_kids/domain/entities/entities.dart';

class LocalProgressDataSource {
  static const _profileBox = 'profile';
  static const _progressBox = 'level_progress';
  static const _drawingBox = 'drawing_saves';
  static const _badgesBox = 'badges';
  static const _adaptiveBox = 'adaptive';
  static const _sessionBox = 'game_sessions';

  Box<dynamic>? _profile;
  Box<dynamic>? _progress;
  Box<dynamic>? _drawing;
  Box<dynamic>? _badges;
  Box<dynamic>? _adaptive;
  Box<dynamic>? _sessions;

  Future<void> init() async {
    await Hive.initFlutter();
    _profile = await Hive.openBox(_profileBox);
    _progress = await Hive.openBox(_progressBox);
    _drawing = await Hive.openBox(_drawingBox);
    _badges = await Hive.openBox(_badgesBox);
    _adaptive = await Hive.openBox(_adaptiveBox);
    _sessions = await Hive.openBox(_sessionBox);
  }

  Future<ChildProfileEntity?> getProfile() async {
    final data = _profile?.get('child') as Map?;
    if (data == null) return null;
    return ChildProfileEntity(
      name: data['name'] as String? ?? 'Explorer',
      ageTierId: data['ageTierId'] as String? ?? 'little_learners',
      totalStars: data['totalStars'] as int? ?? 0,
      totalSessions: data['totalSessions'] as int? ?? 0,
      unlockedZones: (data['unlockedZones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['jungle_grove'],
      earnedBadges: (data['earnedBadges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      conceptMastery: (data['conceptMastery'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
          ) ??
          {},
    );
  }

  Future<void> saveProfile(ChildProfileEntity profile) async {
    await _profile?.put('child', {
      'name': profile.name,
      'ageTierId': profile.ageTierId,
      'totalStars': profile.totalStars,
      'totalSessions': profile.totalSessions,
      'unlockedZones': profile.unlockedZones,
      'earnedBadges': profile.earnedBadges,
      'conceptMastery': profile.conceptMastery,
    });
  }

  Future<LevelProgressEntity?> getLevelProgress(String levelId) async {
    final data = _progress?.get(levelId) as Map?;
    if (data == null) return null;
    return LevelProgressEntity(
      levelId: levelId,
      starsEarned: data['starsEarned'] as int? ?? 0,
      completed: data['completed'] as bool? ?? false,
      attempts: data['attempts'] as int? ?? 0,
      lastPlayedAt: data['lastPlayedAt'] != null
          ? DateTime.parse(data['lastPlayedAt'] as String)
          : null,
      bestTimeMs: data['bestTimeMs'] as int?,
    );
  }

  Future<void> saveLevelProgress(LevelProgressEntity progress) async {
    await _progress?.put(progress.levelId, {
      'starsEarned': progress.starsEarned,
      'completed': progress.completed,
      'attempts': progress.attempts,
      'lastPlayedAt': progress.lastPlayedAt?.toIso8601String(),
      'bestTimeMs': progress.bestTimeMs,
    });
  }

  Future<Map<String, LevelProgressEntity>> getAllLevelProgress() async {
    final result = <String, LevelProgressEntity>{};
    final box = _progress;
    if (box == null) return result;
    for (final key in box.keys) {
      final id = key.toString();
      final progress = await getLevelProgress(id);
      if (progress != null) result[id] = progress;
    }
    return result;
  }

  Future<int> getTotalStars() async {
    final all = await getAllLevelProgress();
    return all.values.fold<int>(0, (sum, p) => sum + p.starsEarned);
  }

  Future<List<String>> getEarnedBadges() async {
    return (_badges?.get('earned') as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
  }

  Future<void> unlockBadge(String badgeId) async {
    final earned = await getEarnedBadges();
    if (!earned.contains(badgeId)) {
      earned.add(badgeId);
      await _badges?.put('earned', earned);
    }
  }

  Future<Map<String, dynamic>> getDrawingSave(String templateId) async {
    final data = _drawing?.get(templateId) as Map?;
    return data != null ? Map<String, dynamic>.from(data) : {};
  }

  Future<void> saveDrawing(String templateId, Map<String, dynamic> data) async {
    await _drawing?.put(templateId, data);
    await _drawing?.put('_last_template', templateId);
  }

  Future<String?> getLastDrawingTemplateId() async {
    return _drawing?.get('_last_template') as String?;
  }

  Future<int?> getGameSessionLevelIndex(String sessionKey) async {
    final data = _sessions?.get(sessionKey) as Map?;
    return data?['levelIndex'] as int?;
  }

  Future<void> saveGameSessionLevelIndex(String sessionKey, int levelIndex) async {
    await _sessions?.put(sessionKey, {
      'levelIndex': levelIndex,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> getAdaptiveData() async {
    final data = _adaptive?.get('concepts') as Map?;
    return data != null ? Map<String, dynamic>.from(data) : {};
  }

  Future<void> saveAdaptiveData(Map<String, dynamic> data) async {
    await _adaptive?.put('concepts', data);
  }
}
