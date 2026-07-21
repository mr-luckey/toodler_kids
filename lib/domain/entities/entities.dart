import 'package:equatable/equatable.dart';

class ZoneEntity extends Equatable {
  const ZoneEntity({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.levelCount,
    required this.gameTypes,
    required this.primaryColor,
    required this.accentColor,
    required this.unlockStars,
    required this.isFree,
    this.isSecret = false,
    this.positionX = 0.5,
    this.positionY = 0.5,
  });

  final String id;
  final String nameKey;
  final String icon;
  final int levelCount;
  final List<String> gameTypes;
  final String primaryColor;
  final String accentColor;
  final int unlockStars;
  final bool isFree;
  final bool isSecret;
  final double positionX;
  final double positionY;

  @override
  List<Object?> get props => [id];
}

class LevelOption extends Equatable {
  const LevelOption({
    required this.id,
    required this.image,
    required this.isCorrect,
    this.labelKey,
  });

  final String id;
  final String image;
  final bool isCorrect;
  final String? labelKey;

  @override
  List<Object?> get props => [id];
}

class LevelFeedback extends Equatable {
  const LevelFeedback({
    required this.correctAnimation,
    required this.correctSound,
    required this.wrongAnimation,
    required this.wrongSound,
    this.lumiEmotionCorrect = 'excited',
    this.noVoiceWrong = true,
  });

  final String correctAnimation;
  final String correctSound;
  final String wrongAnimation;
  final String wrongSound;
  final String lumiEmotionCorrect;
  final bool noVoiceWrong;

  @override
  List<Object?> get props => [];
}

class GameLevelEntity extends Equatable {
  const GameLevelEntity({
    required this.id,
    required this.gameType,
    required this.zoneId,
    required this.levelNumber,
    required this.difficulty,
    required this.starsAvailable,
    required this.scaffoldHints,
    required this.learningMethods,
    this.subMode,
    this.ageTiers = const [],
    this.promptType = 'none',
    this.promptVoiceKey,
    this.lumiLineKey,
    this.referenceImage,
    this.boardRows = 1,
    this.boardCols = 1,
    this.missingSlots = const [],
    this.options = const [],
    this.feedback,
    this.funFactKey,
    this.relatedConcepts = const [],
    this.statementKey,
    this.isTrue,
    this.explanationKey,
    this.clues = const [],
    this.answerId,
    this.items = const [],
    this.bins = const [],
    this.sequenceItems = const [],
    this.tracePath,
    this.phonicsSound,
    this.fillRegions = const [],
    this.suggestedPalette = const [],
    this.svgPath,
    this.backgroundImage,
    this.itemTray = const [],
    this.extra = const {},
  });

  final String id;
  final String gameType;
  final String zoneId;
  final String? subMode;
  final int levelNumber;
  final List<String> ageTiers;
  final int difficulty;
  final int starsAvailable;
  final int scaffoldHints;
  final List<String> learningMethods;
  final String promptType;
  final String? promptVoiceKey;
  final String? lumiLineKey;
  final String? referenceImage;
  final int boardRows;
  final int boardCols;
  final List<Map<String, int>> missingSlots;
  final List<LevelOption> options;
  final LevelFeedback? feedback;
  final String? funFactKey;
  final List<String> relatedConcepts;
  final String? statementKey;
  final bool? isTrue;
  final String? explanationKey;
  final List<String> clues;
  final String? answerId;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> bins;
  final List<Map<String, dynamic>> sequenceItems;
  final String? tracePath;
  final String? phonicsSound;
  final List<Map<String, dynamic>> fillRegions;
  final List<String> suggestedPalette;
  final String? svgPath;
  final String? backgroundImage;
  final List<Map<String, dynamic>> itemTray;
  final Map<String, dynamic> extra;

  @override
  List<Object?> get props => [id];
}

class ManifestEntity extends Equatable {
  const ManifestEntity({
    required this.version,
    required this.contentVersion,
    required this.totalLevels,
    required this.zones,
    required this.gameTypeRegistry,
  });

  final String version;
  final int contentVersion;
  final int totalLevels;
  final List<ZoneEntity> zones;
  final Map<String, Map<String, dynamic>> gameTypeRegistry;

  @override
  List<Object?> get props => [version, contentVersion];
}

class DrawingTemplateEntity extends Equatable {
  const DrawingTemplateEntity({
    required this.id,
    required this.nameKey,
    required this.category,
    required this.svgPath,
    required this.fillRegions,
    required this.suggestedPalette,
    required this.isFree,
    this.displayName,
  });

  final String id;
  final String nameKey;
  final String? displayName;
  final String category;
  final String svgPath;
  final List<Map<String, dynamic>> fillRegions;
  final List<String> suggestedPalette;
  final bool isFree;

  @override
  List<Object?> get props => [id];
}

class FunFactEntity extends Equatable {
  const FunFactEntity({
    required this.id,
    required this.factKey,
    required this.category,
    required this.ageMin,
    required this.relatedConcepts,
  });

  final String id;
  final String factKey;
  final String category;
  final int ageMin;
  final List<String> relatedConcepts;

  @override
  List<Object?> get props => [id];
}

class BadgeEntity extends Equatable {
  const BadgeEntity({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.icon,
    required this.unlockRule,
  });

  final String id;
  final String nameKey;
  final String descriptionKey;
  final String icon;
  final Map<String, dynamic> unlockRule;

  @override
  List<Object?> get props => [id];
}

class StickerAlbumEntity extends Equatable {
  const StickerAlbumEntity({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.slots,
    required this.unlockRule,
  });

  final String id;
  final String nameKey;
  final String icon;
  final int slots;
  final Map<String, dynamic> unlockRule;

  @override
  List<Object?> get props => [id];
}

class LevelProgressEntity extends Equatable {
  const LevelProgressEntity({
    required this.levelId,
    required this.starsEarned,
    required this.completed,
    required this.attempts,
    this.lastPlayedAt,
    this.bestTimeMs,
  });

  final String levelId;
  final int starsEarned;
  final bool completed;
  final int attempts;
  final DateTime? lastPlayedAt;
  final int? bestTimeMs;

  LevelProgressEntity copyWith({
    int? starsEarned,
    bool? completed,
    int? attempts,
    DateTime? lastPlayedAt,
    int? bestTimeMs,
  }) {
    return LevelProgressEntity(
      levelId: levelId,
      starsEarned: starsEarned ?? this.starsEarned,
      completed: completed ?? this.completed,
      attempts: attempts ?? this.attempts,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      bestTimeMs: bestTimeMs ?? this.bestTimeMs,
    );
  }

  @override
  List<Object?> get props => [levelId, starsEarned, completed];
}

class ChildProfileEntity extends Equatable {
  const ChildProfileEntity({
    required this.name,
    required this.ageTierId,
    required this.totalStars,
    required this.totalSessions,
    required this.unlockedZones,
    required this.earnedBadges,
    required this.conceptMastery,
  });

  final String name;
  final String ageTierId;
  final int totalStars;
  final int totalSessions;
  final List<String> unlockedZones;
  final List<String> earnedBadges;
  final Map<String, double> conceptMastery;

  ChildProfileEntity copyWith({
    String? name,
    String? ageTierId,
    int? totalStars,
    int? totalSessions,
    List<String>? unlockedZones,
    List<String>? earnedBadges,
    Map<String, double>? conceptMastery,
  }) {
    return ChildProfileEntity(
      name: name ?? this.name,
      ageTierId: ageTierId ?? this.ageTierId,
      totalStars: totalStars ?? this.totalStars,
      totalSessions: totalSessions ?? this.totalSessions,
      unlockedZones: unlockedZones ?? this.unlockedZones,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      conceptMastery: conceptMastery ?? this.conceptMastery,
    );
  }

  @override
  List<Object?> get props => [name, ageTierId, totalStars];
}
