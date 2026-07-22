import 'dart:convert';
import 'dart:io';

/// Validates JSON content files against basic schema rules.
/// Run: dart run tool/validate_content.dart
void main() {
  final errors = <String>[];
  final assetsDir = Directory('assets/content');

  if (!assetsDir.existsSync()) {
    print('ERROR: assets/content not found');
    exit(1);
  }

  _validateManifest(errors);
  _validateLevelFiles(errors);
  _validateTapMatchLevels(errors);
  _validateZoneAssignments(errors);

  if (errors.isEmpty) {
    print('✅ All content validation passed!');
  } else {
    print('❌ ${errors.length} validation error(s):');
    for (final e in errors) {
      print('  - $e');
    }
    exit(1);
  }
}

void _validateManifest(List<String> errors) {
  final file = File('assets/content/manifest.json');
  if (!file.existsSync()) {
    errors.add('manifest.json missing');
    return;
  }
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  if (json['zones'] == null) errors.add('manifest.json: zones required');
  if (json['gameTypeRegistry'] == null) {
    errors.add('manifest.json: gameTypeRegistry required');
  }
}

void _validateLevelFiles(List<String> errors) {
  final levelFiles = [
    'assets/content/games/complete_picture/levels_001_025.json',
    'assets/content/learning/animals/animal_world.json',
    'assets/content/learning/math/numbers_001_100.json',
    'assets/content/learning/alphabet/letters_001_100.json',
    'assets/content/games/drawing_den/templates.json',
  ];

  for (final path in levelFiles) {
    final file = File(path);
    if (!file.existsSync()) {
      errors.add('Missing: $path');
      continue;
    }
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map && decoded is! List) {
        errors.add('$path: invalid JSON root');
      }
    } catch (e) {
      errors.add('$path: parse error - $e');
    }
  }
}

void _validateTapMatchLevels(List<String> errors) {
  final tapMatchFiles = <String>[];
  for (final entity in Directory('assets/content')
      .listSync(recursive: true)
      .whereType<File>()) {
    if (!entity.path.endsWith('.json')) continue;
    if (entity.path.contains('manifest') ||
        entity.path.contains('localization') ||
        entity.path.contains('badges') ||
        entity.path.contains('stickers') ||
        entity.path.contains('fun_facts') ||
        entity.path.contains('templates') ||
        entity.path.contains('letters_001_100') ||
        entity.path.contains('numbers_001_100') ||
        entity.path.contains('levels_001_025')) {
      continue;
    }
    tapMatchFiles.add(entity.path.replaceAll('\\', '/'));
  }

  for (final path in tapMatchFiles) {
    Map<String, dynamic> root;
    try {
      root = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    } catch (_) {
      continue;
    }

    final levels = root['levels'] as List<dynamic>?;
    if (levels == null) continue;

    for (final levelRaw in levels) {
      if (levelRaw is! Map<String, dynamic>) continue;
      final gameType = levelRaw['gameType'] as String? ?? '';
      final mechanic = _mechanicFor(gameType);
      if (mechanic != 'tap_match' &&
          mechanic != 'name_match' &&
          mechanic != 'opposite_match') {
        continue;
      }

      final levelId = levelRaw['id'] as String? ?? 'unknown';
      final mode = levelRaw['mode'] as String?;
      final items = levelRaw['items'] as List<dynamic>? ?? [];
      final options = levelRaw['options'] as List<dynamic>? ?? [];
      final choices = options.isNotEmpty ? options : items;

      if (choices.isEmpty) {
        errors.add('$path [$levelId]: tap_match level has no choices');
        continue;
      }

      final correct = choices.where((c) {
        if (c is! Map<String, dynamic>) return false;
        return c['isCorrect'] == true;
      }).length;

      if (correct != 1) {
        errors.add(
          '$path [$levelId]: expected exactly 1 correct choice, found $correct',
        );
      }

      if (mode == 'opposite_match' || mechanic == 'opposite_match') {
        final answerId = levelRaw['answerId'] as String?;
        if (answerId != null) {
          final hasAnswer = choices.any((c) {
            if (c is! Map<String, dynamic>) return false;
            return _idMatches(c['id'] as String?, answerId);
          });
          if (!hasAnswer) {
            errors.add(
              '$path [$levelId]: opposite answer "$answerId" missing from choices',
            );
          }
        }
        continue;
      }

      final targetId = levelRaw['targetId'] as String?;
      final related = (levelRaw['relatedConcepts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];
      final conceptTarget =
          related.isNotEmpty ? related.first.split('.').last : null;
      final expectedTarget = targetId ?? conceptTarget;

      if (expectedTarget != null) {
        final hasTarget = choices.any((c) {
          if (c is! Map<String, dynamic>) return false;
          return _idMatches(c['id'] as String?, expectedTarget);
        });
        if (!hasTarget) {
          errors.add(
            '$path [$levelId]: target "$expectedTarget" missing from choices',
          );
        }
      }
    }
  }
}

String _mechanicFor(String gameType) {
  const tapMatch = {
    'animal_world',
    'animal_names',
    'number_recognition',
    'counting',
    'letter_recognition',
    'letter_phonics',
    'dino_names',
    'space_objects',
    'sports_names',
    'four_seasons',
    'household_items',
    'fun_colors',
    'color_recognition',
  };
  if (gameType == 'opposites') return 'opposite_match';
  if (tapMatch.contains(gameType) || gameType == 'animal_names') {
    return gameType == 'animal_names' ? 'name_match' : 'tap_match';
  }
  if (gameType == 'which_tool_works' || gameType == 'complete_picture') {
    return 'select_piece';
  }
  return 'other';
}

bool _idMatches(String? id, String targetId) {
  final value = id?.toLowerCase() ?? '';
  final target = targetId.toLowerCase();
  if (value == target) return true;
  if (value.replaceAll('_', '') == target.replaceAll('_', '')) return true;
  if (value.endsWith('_$target') || value.endsWith(target)) return true;
  return false;
}

void _validateZoneAssignments(List<String> errors) {
  final manifestFile = File('assets/content/manifest.json');
  if (!manifestFile.existsSync()) return;

  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  final zones = manifest['zones'] as List<dynamic>? ?? [];
  final registry =
      manifest['gameTypeRegistry'] as Map<String, dynamic>? ?? {};

  final gameToZones = <String, Set<String>>{};
  for (final zoneRaw in zones) {
    if (zoneRaw is! Map<String, dynamic>) continue;
    final zoneId = zoneRaw['id'] as String? ?? '';
    final gameTypes = zoneRaw['gameTypes'] as List<dynamic>? ?? [];
    for (final gt in gameTypes) {
      if (gt is! String || gt == 'coloring' || gt == 'free_draw') continue;
      gameToZones.putIfAbsent(gt, () => {}).add(zoneId);
    }
  }

  for (final entry in registry.entries) {
    final gameType = entry.key;
    final info = entry.value as Map<String, dynamic>;
    final paths = (info['contentPaths'] as List<dynamic>? ?? [])
        .map((e) => e as String)
        .toList();
    final minLevels = info['minLevels'] as int? ?? 0;
    var totalLevels = 0;

    for (final path in paths) {
      final file = File(path);
      if (!file.existsSync()) {
        errors.add('Registry $gameType: missing content file $path');
        continue;
      }
      final root = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final levels = root['levels'] as List<dynamic>? ?? [];
      totalLevels += levels.length;

      for (final levelRaw in levels) {
        if (levelRaw is! Map<String, dynamic>) continue;
        final levelId = levelRaw['id'] as String? ?? 'unknown';
        final zoneId = levelRaw['zoneId'] as String?;
        final expectedZones = gameToZones[gameType];
        if (expectedZones != null &&
            zoneId != null &&
            !expectedZones.contains(zoneId)) {
          errors.add(
            '$path [$levelId]: zoneId "$zoneId" not in manifest zones for $gameType ($expectedZones)',
          );
        }
      }
    }

    if (totalLevels < minLevels) {
      errors.add(
        'Registry $gameType: $totalLevels levels, expected min $minLevels',
      );
    }
  }
}
