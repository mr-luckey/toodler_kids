import 'package:flutter_test/flutter_test.dart';
import 'package:toodler_kids/core/adaptive/adaptive_engine.dart';
import 'package:toodler_kids/core/game_engine/level_choice_builder.dart';
import 'package:toodler_kids/data/models/content_models.dart';
import 'package:toodler_kids/domain/entities/entities.dart';

void main() {
  group('LevelModel', () {
    test('parses complete picture level from JSON', () {      final level = LevelModel.fromJson({
        'id': 'cp_001',
        'gameType': 'complete_picture',
        'zoneId': 'puzzle_palace',
        'levelNumber': 1,
        'options': [
          {'id': 'a', 'image': 'test.png', 'isCorrect': true},
          {'id': 'b', 'image': 'test2.png', 'isCorrect': false},
        ],
        'feedback': {
          'correct': {'animation': 'slide_in', 'sound': 'chime'},
          'wrong': {'animation': 'bounce_back', 'sound': 'soft_boop', 'noVoiceWrong': true},
        },
      }).toEntity();

      expect(level.id, 'cp_001');
      expect(level.options.length, 2);
      expect(level.options.first.isCorrect, true);
      expect(level.feedback?.noVoiceWrong, true);
    });

    test('reads lumiLineKey from root JSON for tap match', () {
      final level = LevelModel.fromJson({
        'id': 'animal_world_001',
        'gameType': 'animal_world',
        'zoneId': 'jungle_grove',
        'levelNumber': 1,
        'lumiLineKey': 'Find the Lion!',
        'targetId': 'lion',
        'items': [
          {'id': 'giraffe', 'emoji': '🦒', 'label': 'Giraffe', 'isCorrect': false},
        ],
        'relatedConcepts': ['jungle_grove.lion'],
      }).toEntity();

      expect(level.lumiLineKey, 'Find the Lion!');
      expect(level.extra['targetId'], 'lion');
    });
  });

  group('LevelChoiceBuilder', () {
    test('repairs broken tap match choices using relatedConcepts', () {
      const level = GameLevelEntity(
        id: 'animal_world_001',
        gameType: 'animal_world',
        zoneId: 'jungle_grove',
        levelNumber: 1,
        difficulty: 1,
        starsAvailable: 3,
        scaffoldHints: 2,
        learningMethods: const ['play_based'],
        lumiLineKey: 'Find the Lion!',
        relatedConcepts: ['jungle_grove.lion'],
        items: [
          {'id': 'giraffe', 'emoji': '🦒', 'label': 'Giraffe', 'isCorrect': false},
          {'id': 'cow', 'emoji': '🐄', 'label': 'Cow', 'isCorrect': false},
          {'id': 'bear', 'emoji': '🐻', 'label': 'Bear', 'isCorrect': false},
          {'id': 'penguin', 'emoji': '🐧', 'label': 'Penguin', 'isCorrect': false},
        ],
      );

      final choices = LevelChoiceBuilder.buildChoices(level);
      final correct = choices.where((c) => c['isCorrect'] == true).toList();

      expect(correct.length, 1);
      expect(correct.first['id'], 'lion');
      expect(choices.length, 4);
    });

    test('extracts target display for hero card', () {
      const level = GameLevelEntity(
        id: 'animal_world_001',
        gameType: 'animal_world',
        zoneId: 'jungle_grove',
        levelNumber: 1,
        difficulty: 1,
        starsAvailable: 3,
        scaffoldHints: 2,
        learningMethods: const ['play_based'],
        lumiLineKey: 'Find the Lion!',
        relatedConcepts: ['jungle_grove.lion'],
        items: const [],
      );

      final target = LevelChoiceBuilder.targetDisplay(level);
      expect(target?['id'], 'lion');
      expect(target?['emoji'], '🦁');
      expect(target?['label'], 'Lion');
    });

    test('builds opposite match choices from answerId', () {
      const level = GameLevelEntity(
        id: 'opposites_001',
        gameType: 'opposites',
        zoneId: 'opposites_ocean',
        levelNumber: 1,
        difficulty: 1,
        starsAvailable: 3,
        scaffoldHints: 2,
        learningMethods: const ['inquiry'],
        lumiLineKey: 'What is the OPPOSITE of Big?',
        answerId: 'small',
        extra: const {
          'mode': 'opposite_match',
          'targetId': 'big',
          'sourceDisplay': {'id': 'big', 'emoji': '🐘', 'label': 'Big'},
        },
        items: const [
          {'id': 'small', 'label': 'Small', 'isCorrect': true},
          {'id': 'hot', 'label': 'Hot', 'isCorrect': false},
          {'id': 'fast', 'label': 'Fast', 'isCorrect': false},
          {'id': 'up', 'label': 'Up', 'isCorrect': false},
        ],
      );

      final choices = LevelChoiceBuilder.buildChoices(level);
      final correct = choices.where((c) => c['isCorrect'] == true).toList();
      expect(correct.length, 1);
      expect(correct.first['id'], 'small');

      final source = LevelChoiceBuilder.sourceDisplay(level);
      expect(source?['id'], 'big');
      expect(source?['emoji'], '🐘');
    });
  });

  group('AdaptiveEngine', () {    test('records attempts and schedules review', () async {
      final engine = AdaptiveEngine();
      await engine.recordAttempt(
        concept: 'animals.cow',
        success: true,
        stars: 3,
      );
      await engine.recordAttempt(
        concept: 'animals.cow',
        success: false,
        stars: 0,
      );

      final map = engine.getLearningMap();
      expect(map.length, 1);
      expect(map.first.concept, 'animals.cow');
    });

    test('reduces scaffold hints for mastered concepts', () {
      final engine = AdaptiveEngine();
      // Without records, returns base hints
      expect(engine.getScaffoldHintsAvailable(3, 'new.concept'), 3);
    });
  });
}
