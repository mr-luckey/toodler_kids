import 'dart:math';

import 'package:toodler_kids/core/assets/game_image_resolver.dart';
import 'package:toodler_kids/domain/entities/entities.dart';

/// Builds and repairs tap-match / choice lists so every level has exactly one
/// correct answer that matches the prompt and related concepts.
class LevelChoiceBuilder {
  LevelChoiceBuilder._();

  static final _rng = Random();

  static const _emojiCatalog = {
    'lion': '🦁',
    'elephant': '🐘',
    'giraffe': '🦒',
    'monkey': '🐵',
    'cow': '🐄',
    'sheep': '🐑',
    'pig': '🐖',
    'chicken': '🐓',
    'horse': '🐴',
    'duck': '🦆',
    'frog': '🐸',
    'bear': '🐻',
    'penguin': '🐧',
    'shark': '🦈',
    'butterfly': '🦋',
    'trex': '🦖',
    'triceratops': '🦕',
    'stego': '🦴',
    'brachio': '🦕',
    'veloci': '🦖',
    'ptero': '🦅',
    'ankylo': '🦕',
    'spino': '🦖',
    'sun': '☀️',
    'moon': '🌙',
    'earth': '🌍',
    'mars': '🔴',
    'rocket': '🚀',
    'saturn': '🪐',
    'star': '⭐',
    'comet': '☄️',
    'football': '⚽',
    'basketball': '🏀',
    'tennis': '🎾',
    'swimming': '🏊',
    'cricket': '🏏',
    'golf': '⛳',
    'skiing': '⛷️',
    'spring': '🌸',
    'summer': '☀️',
    'autumn': '🍂',
    'winter': '❄️',
    'bed': '🛏️',
    'chair': '🪑',
    'table': '🪑',
    'lamp': '💡',
    'door': '🚪',
    'window': '🪟',
    'cup': '☕',
    'plate': '🍽️',
    'spoon': '🥄',
    'book': '📚',
    'red': '🔴',
    'blue': '🔵',
    'green': '🟢',
    'yellow': '🟡',
    'orange': '🟠',
    'purple': '🟣',
    'pink': '🩷',
    'black': '⚫',
    'white': '⚪',
    'big': '🐘',
    'small': '🐜',
    'hot': '🔥',
    'cold': '❄️',
    'fast': '🐆',
    'slow': '🐢',
    'up': '⬆️',
    'down': '⬇️',
    'day': '☀️',
    'night': '🌙',
    'banana': '🍌',
    'tomato': '🍅',
    'apple': '🍎',
    'cat': '🐱',
    'dog': '🐶',
    'fish': '🐟',
    'hammer': '🔨',
    'wrench': '🔧',
    'screwdriver': '🪛',
  };

  /// Target id from JSON, related concepts, or prompt text.
  static String? extractTargetId(GameLevelEntity level) {
    final fromExtra = level.extra['targetId']?.toString();
    if (fromExtra != null && fromExtra.isNotEmpty) return fromExtra;

    for (final concept in level.relatedConcepts) {
      final parts = concept.split('.');
      if (parts.length >= 2) {
        final id = parts.last;
        if (id.isNotEmpty) return id;
      }
    }

    final prompt = level.lumiLineKey;
    if (prompt != null) {
      final match = RegExp(
        r'Find the (.+?)!?',
        caseSensitive: false,
      ).firstMatch(prompt);
      if (match != null) {
        return _labelToId(match.group(1)!);
      }
    }

    if (level.answerId != null && level.answerId!.isNotEmpty) {
      return level.answerId;
    }

    for (final option in level.options) {
      if (option.isCorrect) return option.id;
    }

    for (final item in level.items) {
      if (item['isCorrect'] == true) {
        return item['id']?.toString();
      }
    }

    return null;
  }

  /// Hero card data for "find this" tap-match levels.
  static Map<String, dynamic>? targetDisplay(GameLevelEntity level) {
    final targetId = extractTargetId(level);
    if (targetId == null) return null;

    for (final item in level.items) {
      if (_idMatches(item['id'], targetId)) {
        return GameImageResolver.enrichChoice({
          'id': item['id'],
          'emoji': item['emoji'] ?? emojiForId(targetId),
          'label': item['label'] ?? labelForId(targetId, level.lumiLineKey),
        });
      }
    }

    for (final option in level.options) {
      if (_idMatches(option.id, targetId)) {
        return GameImageResolver.enrichChoice({
          'id': option.id,
          'emoji': emojiForId(option.id),
          'label': option.labelKey ?? labelForId(option.id, level.lumiLineKey),
        });
      }
    }

    return GameImageResolver.enrichChoice({
      'id': targetId,
      'emoji': emojiForId(targetId),
      'label': labelForId(targetId, level.lumiLineKey),
    });
  }

  static List<Map<String, dynamic>> buildChoices(GameLevelEntity level) {
    if (level.options.isNotEmpty) {
      final choices = level.options
          .map(
            (o) => {
              'id': o.id,
              'emoji': emojiForId(o.id),
              'label': o.labelKey ?? labelForId(o.id, level.lumiLineKey),
              'isCorrect': o.isCorrect,
            },
          )
          .toList();
      return GameImageResolver.enrichChoices(choices);
    }

    final targetId = extractTargetId(level);
    var raw = level.items.map((i) => Map<String, dynamic>.from(i)).toList();

    if (targetId != null) {
      for (final choice in raw) {
        choice['isCorrect'] = _idMatches(choice['id'], targetId);
      }

      if (!raw.any((c) => _idMatches(c['id'], targetId))) {
        raw.add(_syntheticChoice(targetId, level.lumiLineKey));
      }

      final correct =
          raw.firstWhere((c) => _idMatches(c['id'], targetId));
      final wrongs = raw.where((c) => !_idMatches(c['id'], targetId)).toList()
        ..shuffle(_rng);
      raw = [correct, ...wrongs.take(3)];
      raw.shuffle(_rng);
    }

    for (final choice in raw) {
      choice['emoji'] ??= emojiForId(choice['id']?.toString() ?? '');
      choice['label'] ??=
          labelForId(choice['id']?.toString() ?? '', level.lumiLineKey);
    }

    return GameImageResolver.enrichChoices(raw);
  }

  static String emojiForId(String id) {
    if (id.startsWith('num_')) return id.replaceAll('num_', '');
    if (id.startsWith('letter_')) return id.replaceAll('letter_', '');
    return _emojiCatalog[id.toLowerCase()] ?? '⭐';
  }

  static String labelForId(String id, String? lumiLineKey) {
    final fromPrompt = _labelFromLumiKey(lumiLineKey);
    if (fromPrompt != null && _idMatches(id, _labelToId(fromPrompt))) {
      return fromPrompt;
    }
    if (id.startsWith('num_')) return id.replaceAll('num_', '');
    if (id.startsWith('letter_')) return id.replaceAll('letter_', '');
    if (id.contains('_')) {
      return id
          .split('_')
          .map((part) =>
              part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' ');
    }
    if (id.isEmpty) return '';
    return '${id[0].toUpperCase()}${id.substring(1)}';
  }

  static Map<String, dynamic> _syntheticChoice(String targetId, String? prompt) {
    return {
      'id': targetId,
      'emoji': emojiForId(targetId),
      'label': labelForId(targetId, prompt),
      'isCorrect': true,
    };
  }

  static bool _idMatches(Object? id, String targetId) {
    final value = id?.toString().toLowerCase() ?? '';
    final target = targetId.toLowerCase();
    return value == target ||
        value.replaceAll('_', '') == target.replaceAll('_', '');
  }

  static String _labelToId(String label) {
    return label.trim().toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
  }

  static String? _labelFromLumiKey(String? lumiLineKey) {
    if (lumiLineKey == null) return null;
    final match = RegExp(
      r'Find the (.+?)!?',
      caseSensitive: false,
    ).firstMatch(lumiLineKey);
    return match?.group(1)?.trim();
  }
}
