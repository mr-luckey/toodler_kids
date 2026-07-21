import 'package:toodler_kids/domain/entities/entities.dart';

class ZoneModel {
  ZoneModel({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.levelCount,
    required this.gameTypes,
    required this.palette,
    required this.unlockStars,
    required this.isFree,
    this.isSecret = false,
    this.positionX = 0.5,
    this.positionY = 0.5,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    final palette = json['palette'] as Map<String, dynamic>? ?? {};
    return ZoneModel(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      icon: json['icon'] as String? ?? '',
      levelCount: json['levelCount'] as int? ?? 0,
      gameTypes: (json['gameTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      palette: palette,
      unlockStars: json['unlockStars'] as int? ?? 0,
      isFree: json['isFree'] as bool? ?? false,
      isSecret: json['isSecret'] as bool? ?? false,
      positionX: (json['positionX'] as num?)?.toDouble() ?? 0.5,
      positionY: (json['positionY'] as num?)?.toDouble() ?? 0.5,
    );
  }

  final String id;
  final String nameKey;
  final String icon;
  final int levelCount;
  final List<String> gameTypes;
  final Map<String, dynamic> palette;
  final int unlockStars;
  final bool isFree;
  final bool isSecret;
  final double positionX;
  final double positionY;

  ZoneEntity toEntity() => ZoneEntity(
        id: id,
        nameKey: nameKey,
        icon: icon,
        levelCount: levelCount,
        gameTypes: gameTypes,
        primaryColor: palette['primary'] as String? ?? '#4CAF50',
        accentColor: palette['accent'] as String? ?? '#FF9800',
        unlockStars: unlockStars,
        isFree: isFree,
        isSecret: isSecret,
        positionX: positionX,
        positionY: positionY,
      );
}

class LevelModel {
  LevelModel({required this.raw});

  factory LevelModel.fromJson(Map<String, dynamic> json) =>
      LevelModel(raw: json);

  final Map<String, dynamic> raw;

  GameLevelEntity toEntity() {
    final prompt = raw['prompt'] as Map<String, dynamic>? ?? {};
    final board = raw['board'] as Map<String, dynamic>? ?? {};
    final feedbackRaw = raw['feedback'] as Map<String, dynamic>?;
    final correct = feedbackRaw?['correct'] as Map<String, dynamic>? ?? {};
    final wrong = feedbackRaw?['wrong'] as Map<String, dynamic>? ?? {};

    final optionsRaw = raw['options'] as List<dynamic>? ?? [];
    final options = optionsRaw.map((o) {
      final m = o as Map<String, dynamic>;
      return LevelOption(
        id: m['id'] as String,
        image: m['image'] as String? ?? '',
        isCorrect: m['isCorrect'] as bool? ?? false,
        labelKey: m['labelKey'] as String?,
      );
    }).toList();

    final missingSlots = (board['missingSlots'] as List<dynamic>? ?? [])
        .map((s) => Map<String, int>.from(s as Map))
        .toList();

    return GameLevelEntity(
      id: raw['id'] as String,
      gameType: raw['gameType'] as String,
      zoneId: raw['zoneId'] as String,
      subMode: raw['subMode'] as String?,
      levelNumber: raw['levelNumber'] as int? ?? 0,
      ageTiers: (raw['ageTier'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (raw['ageTiers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      difficulty: raw['difficulty'] as int? ?? 1,
      starsAvailable: raw['starsAvailable'] as int? ?? 3,
      scaffoldHints: raw['scaffoldHints'] as int? ?? 3,
      learningMethods: (raw['learningMethod'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (raw['learningMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      promptType: prompt['type'] as String? ?? 'none',
      promptVoiceKey: prompt['voiceKey'] as String?,
      lumiLineKey:
          prompt['lumiLineKey'] as String? ?? raw['lumiLineKey'] as String?,
      referenceImage: raw['referenceImage'] as String?,
      boardRows: board['gridRows'] as int? ?? 1,
      boardCols: board['gridCols'] as int? ?? 1,
      missingSlots: missingSlots,
      options: options,
      feedback: feedbackRaw != null
          ? LevelFeedback(
              correctAnimation: correct['animation'] as String? ?? 'slide_in',
              correctSound: correct['sound'] as String? ?? 'chime',
              wrongAnimation: wrong['animation'] as String? ?? 'bounce_back',
              wrongSound: wrong['sound'] as String? ?? 'soft_boop',
              lumiEmotionCorrect:
                  correct['lumiEmotion'] as String? ?? 'excited',
              noVoiceWrong: wrong['noVoiceWrong'] as bool? ?? true,
            )
          : null,
      funFactKey: raw['funFactKey'] as String?,
      relatedConcepts: (raw['relatedConcepts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      statementKey: raw['statementKey'] as String?,
      isTrue: raw['isTrue'] as bool?,
      explanationKey: raw['explanationKey'] as String?,
      clues: (raw['clues'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      answerId: raw['answerId'] as String?,
      items: (raw['items'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      bins: (raw['bins'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      sequenceItems: (raw['sequenceItems'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      tracePath: raw['tracePath'] as String?,
      phonicsSound: raw['phonicsSound'] as String?,
      fillRegions: (raw['fillRegions'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      suggestedPalette: (raw['suggestedPalette'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      svgPath: raw['svgPath'] as String?,
      backgroundImage: raw['backgroundImage'] as String?,
      itemTray: (raw['itemTray'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      extra: {
        ...Map<String, dynamic>.from(raw['extra'] as Map? ?? {}),
        if (raw['targetId'] != null) 'targetId': raw['targetId'],
        if (raw['mode'] != null) 'mode': raw['mode'],
      },
    );
  }
}

class ManifestModel {
  ManifestModel({
    required this.version,
    required this.contentVersion,
    required this.totalLevels,
    required this.zones,
    required this.gameTypeRegistry,
  });

  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    return ManifestModel(
      version: json['version'] as String? ?? '1.0.0',
      contentVersion: json['contentVersion'] as int? ?? 1,
      totalLevels: json['totalLevels'] as int? ?? 0,
      zones: (json['zones'] as List<dynamic>?)
              ?.map((z) => ZoneModel.fromJson(z as Map<String, dynamic>))
              .toList() ??
          [],
      gameTypeRegistry: (json['gameTypeRegistry'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map))) ??
          {},
    );
  }

  final String version;
  final int contentVersion;
  final int totalLevels;
  final List<ZoneModel> zones;
  final Map<String, Map<String, dynamic>> gameTypeRegistry;

  ManifestEntity toEntity() => ManifestEntity(
        version: version,
        contentVersion: contentVersion,
        totalLevels: totalLevels,
        zones: zones.map((z) => z.toEntity()).toList(),
        gameTypeRegistry: gameTypeRegistry,
      );
}

class DrawingTemplateModel {
  DrawingTemplateModel({required this.raw});

  factory DrawingTemplateModel.fromJson(Map<String, dynamic> json) =>
      DrawingTemplateModel(raw: json);

  final Map<String, dynamic> raw;

  DrawingTemplateEntity toEntity() => DrawingTemplateEntity(
        id: raw['id'] as String,
        nameKey: raw['nameKey'] as String,
        displayName: raw['displayName'] as String?,
        category: raw['category'] as String? ?? 'general',
        svgPath: raw['svgPath'] as String,
        fillRegions: (raw['fillRegions'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e as Map))
                .toList() ??
            [],
        suggestedPalette: (raw['suggestedPalette'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        isFree: raw['isFree'] as bool? ?? false,
      );
}
