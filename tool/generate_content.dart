// KidsLearnPlay — Full JSON content generator
// Run: dart run tool/generate_content.dart

import 'dart:convert';
import 'dart:io';
import 'dart:math';

final _rng = Random(42);

void main() {
  _generateCompletePicture500();
  _generateAnimalWorld(80);
  _generateAnimalNames(100);
  _generateTapMatch('number_recognition', 'number_mountain', _numbers, 100);
  _generateTapMatch('counting', 'number_mountain', _numbers, 100);
  _generateTapMatch('letter_recognition', 'letter_lane', _letters, 100);
  _generateTapMatch('letter_phonics', 'letter_lane', _letters, 100);
  _generateTapMatch('dino_names', 'dinosaurs', _dinos, 100);
  _generateTapMatch('space_objects', 'space_science', _space, 100);
  _generateTapMatch('sports_names', 'sports_body', _sports, 100);
  _generateTapMatch('four_seasons', 'seasons_holidays', _seasons, 80);
  _generateTapMatch('household_items', 'household_daily', _household, 100);
  _generateTapMatch('fun_colors', 'color_canyon', _colors, 100);
  _generateTapMatch('color_recognition', 'color_canyon', _colors, 100);
  _generateTapMatch('opposites', 'opposites_ocean', _opposites, 100);
  _generateWhichToolWorks(100);
  _generateShadowGame(100);
  _generateTrueFalse('true_false_animals', 'jungle_grove', _tfAnimals, 100);
  _generateTrueFalse('true_false_dino', 'dinosaurs', _tfDino, 80);
  _generateTrueFalse('true_false_space', 'space_science', _tfSpace, 80);
  _generateWhatAmI(80);
  _generateBuildScene();
  // Drawing templates: run `dart run tool/generate_drawing_svgs.dart` separately.
  _generateFunFacts(100);
  _generateBadges();
  _generateStickers();
  _generateLocalization();
  _generateManifest();
  stdout.writeln('✅ Full content generation complete!');
}

// ─── Data pools ───────────────────────────────────────────────

final _animals = [
  {'id': 'lion', 'emoji': '🦁', 'label': 'Lion'},
  {'id': 'elephant', 'emoji': '🐘', 'label': 'Elephant'},
  {'id': 'giraffe', 'emoji': '🦒', 'label': 'Giraffe'},
  {'id': 'monkey', 'emoji': '🐵', 'label': 'Monkey'},
  {'id': 'cow', 'emoji': '🐄', 'label': 'Cow'},
  {'id': 'sheep', 'emoji': '🐑', 'label': 'Sheep'},
  {'id': 'pig', 'emoji': '🐖', 'label': 'Pig'},
  {'id': 'chicken', 'emoji': '🐓', 'label': 'Chicken'},
  {'id': 'horse', 'emoji': '🐴', 'label': 'Horse'},
  {'id': 'duck', 'emoji': '🦆', 'label': 'Duck'},
  {'id': 'frog', 'emoji': '🐸', 'label': 'Frog'},
  {'id': 'bear', 'emoji': '🐻', 'label': 'Bear'},
  {'id': 'penguin', 'emoji': '🐧', 'label': 'Penguin'},
  {'id': 'shark', 'emoji': '🦈', 'label': 'Shark'},
  {'id': 'butterfly', 'emoji': '🦋', 'label': 'Butterfly'},
];

final _numbers = List.generate(20, (i) {
  final n = i + 1;
  return {'id': 'num_$n', 'emoji': '$n', 'label': '$n'};
});

final _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((l) => {
      'id': 'letter_$l', 'emoji': l, 'label': l,
    }).toList();

final _dinos = [
  {'id': 'trex', 'emoji': '🦖', 'label': 'T-Rex'},
  {'id': 'triceratops', 'emoji': '🦕', 'label': 'Triceratops'},
  {'id': 'stego', 'emoji': '🦴', 'label': 'Stegosaurus'},
  {'id': 'brachio', 'emoji': '🦕', 'label': 'Brachiosaurus'},
  {'id': 'veloci', 'emoji': '🦖', 'label': 'Velociraptor'},
  {'id': 'ptero', 'emoji': '🦅', 'label': 'Pterodactyl'},
  {'id': 'ankylo', 'emoji': '🦴', 'label': 'Ankylosaurus'},
  {'id': 'spino', 'emoji': '🦖', 'label': 'Spinosaurus'},
];

final _space = [
  {'id': 'sun', 'emoji': '☀️', 'label': 'Sun'},
  {'id': 'moon', 'emoji': '🌙', 'label': 'Moon'},
  {'id': 'earth', 'emoji': '🌍', 'label': 'Earth'},
  {'id': 'mars', 'emoji': '🔴', 'label': 'Mars'},
  {'id': 'rocket', 'emoji': '🚀', 'label': 'Rocket'},
  {'id': 'saturn', 'emoji': '🪐', 'label': 'Saturn'},
  {'id': 'star', 'emoji': '⭐', 'label': 'Star'},
  {'id': 'comet', 'emoji': '☄️', 'label': 'Comet'},
];

final _sports = [
  {'id': 'football', 'emoji': '⚽', 'label': 'Football'},
  {'id': 'basketball', 'emoji': '🏀', 'label': 'Basketball'},
  {'id': 'tennis', 'emoji': '🎾', 'label': 'Tennis'},
  {'id': 'swimming', 'emoji': '🏊', 'label': 'Swimming'},
  {'id': 'cricket', 'emoji': '🏏', 'label': 'Cricket'},
  {'id': 'golf', 'emoji': '⛳', 'label': 'Golf'},
  {'id': 'skiing', 'emoji': '⛷️', 'label': 'Skiing'},
  {'id': 'boxing', 'emoji': '🥊', 'label': 'Boxing'},
];

final _seasons = [
  {'id': 'spring', 'emoji': '🌸', 'label': 'Spring'},
  {'id': 'summer', 'emoji': '☀️', 'label': 'Summer'},
  {'id': 'autumn', 'emoji': '🍂', 'label': 'Autumn'},
  {'id': 'winter', 'emoji': '❄️', 'label': 'Winter'},
];

final _household = [
  {'id': 'fridge', 'emoji': '🧊', 'label': 'Fridge'},
  {'id': 'bed', 'emoji': '🛏️', 'label': 'Bed'},
  {'id': 'sofa', 'emoji': '🛋️', 'label': 'Sofa'},
  {'id': 'toilet', 'emoji': '🚽', 'label': 'Toilet'},
  {'id': 'tv', 'emoji': '📺', 'label': 'TV'},
  {'id': 'lamp', 'emoji': '💡', 'label': 'Lamp'},
  {'id': 'clock', 'emoji': '🕐', 'label': 'Clock'},
  {'id': 'broom', 'emoji': '🧹', 'label': 'Broom'},
];

final _colors = [
  {'id': 'red', 'emoji': '🔴', 'label': 'Red'},
  {'id': 'blue', 'emoji': '🔵', 'label': 'Blue'},
  {'id': 'green', 'emoji': '🟢', 'label': 'Green'},
  {'id': 'yellow', 'emoji': '🟡', 'label': 'Yellow'},
  {'id': 'orange', 'emoji': '🟠', 'label': 'Orange'},
  {'id': 'purple', 'emoji': '🟣', 'label': 'Purple'},
  {'id': 'pink', 'emoji': '🩷', 'label': 'Pink'},
  {'id': 'brown', 'emoji': '🟤', 'label': 'Brown'},
];

final _opposites = [
  {'id': 'big', 'emoji': '🐘', 'label': 'Big', 'pair': 'small'},
  {'id': 'hot', 'emoji': '🔥', 'label': 'Hot', 'pair': 'cold'},
  {'id': 'fast', 'emoji': '🐆', 'label': 'Fast', 'pair': 'slow'},
  {'id': 'up', 'emoji': '⬆️', 'label': 'Up', 'pair': 'down'},
  {'id': 'day', 'emoji': '☀️', 'label': 'Day', 'pair': 'night'},
];

final _tfAnimals = [
  ('Elephants can recognize themselves in a mirror.', true),
  ('Cats bark like dogs.', false),
  ('Dolphins are mammals.', true),
  ('Fish have lungs like humans.', false),
  ('Bees make honey.', true),
  ('Penguins can fly high in the sky.', false),
  ('Owls can turn their heads far around.', true),
  ('All snakes have legs.', false),
];

final _tfDino = [
  ('T-Rex had tiny arms.', true),
  ('Dinosaurs are still alive as birds.', true),
  ('Stegosaurus ate meat.', false),
  ('Brachiosaurus had a very long neck.', true),
  ('All dinosaurs lived in water.', false),
];

final _tfSpace = [
  ('The Sun is a star.', true),
  ('You can breathe on the Moon.', false),
  ('Saturn has rings.', true),
  ('Mars is called the Red Planet.', true),
  ('The Moon makes its own light.', false),
];

// ─── Generators ───────────────────────────────────────────────

void _writeJson(String path, Object data) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  stdout.writeln('  → $path');
}

Map<String, dynamic> _feedback() => {
      'correct': {'animation': 'slide_in', 'sound': 'chime', 'lumiEmotion': 'excited'},
      'wrong': {'animation': 'bounce_back', 'sound': 'soft_boop', 'noVoiceWrong': true},
    };

void _generateCompletePicture500() {
  final themes = ['cow', 'sheep', 'pig', 'lion', 'elephant', 'giraffe', 'monkey', 'rocket', 'dino', 'tree'];
  for (var batch = 0; batch < 5; batch++) {
    final levels = <Map<String, dynamic>>[];
    for (var i = 1; i <= 100; i++) {
      final num = batch * 100 + i;
      final theme = themes[num % themes.length];
      final choiceCount = num <= 100 ? 2 : (num <= 300 ? 3 : 4);
      final options = <Map<String, dynamic>>[
        {'id': 'correct', 'image': 'assets/images/games/$theme.png', 'isCorrect': true},
      ];
      for (var j = 1; j < choiceCount; j++) {
        options.add({
          'id': 'wrong_$j',
          'image': 'assets/images/games/${themes[(num + j) % themes.length]}.png',
          'isCorrect': false,
        });
      }
      options.shuffle(_rng);
      levels.add({
        'id': 'cp_${num.toString().padLeft(3, '0')}',
        'gameType': 'complete_picture',
        'zoneId': 'puzzle_palace',
        'subMode': num <= 100
            ? 'single_missing_piece'
            : num <= 200
                ? 'two_missing_pieces'
                : num <= 300
                    ? 'three_missing_pieces'
                    : num <= 400
                        ? 'pattern_completion'
                        : 'face_completion',
        'levelNumber': num,
        'ageTier': ['little_learners'],
        'difficulty': (num / 50).ceil().clamp(1, 5),
        'learningMethod': ['montessori', 'scaffolding'],
        'starsAvailable': 3,
        'scaffoldHints': 3,
        'prompt': {'type': 'none', 'lumiLineKey': 'lumi.complete_picture.hint'},
        'referenceImage': 'assets/images/games/${theme}_full.png',
        'board': {'gridRows': 3, 'gridCols': 3, 'missingSlots': [{'row': 1, 'col': 1}]},
        'options': options,
        'feedback': _feedback(),
        'funFactKey': num % 3 == 0 ? 'facts.$theme.default' : null,
        'relatedConcepts': ['visual.complete.$theme'],
      });
    }
    final start = batch * 100 + 1;
    final end = batch * 100 + 100;
    _writeJson(
      'assets/content/games/complete_picture/levels_${start.toString().padLeft(3, '0')}_${end.toString().padLeft(3, '0')}.json',
      {'levels': levels},
    );
  }
}

/// RV-style quick tap: hear the name → tap the matching animal picture (no hero hint).
void _generateAnimalWorld(int count) {
  _generateTapMatch(
    'animal_world',
    'jungle_grove',
    _animals,
    count,
    promptBuilder: (label) => 'Tap the $label!',
    mode: 'quick_tap',
    poolOffset: 0,
  );
}

/// Literacy mode: see the animal → pick the correct written name.
void _generateAnimalNames(int count) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final target = _animals[(i + 5) % _animals.length];
    final wrongPool = _animals.where((a) => a['id'] != target['id']).toList()
      ..shuffle(_rng);
    final items = [
      {
        'id': target['id'],
        'label': target['label'],
        'isCorrect': true,
      },
      ...wrongPool.take(3).map(
            (a) => {
              'id': a['id'],
              'label': a['label'],
              'isCorrect': false,
            },
          ),
    ]..shuffle(_rng);
    levels.add({
      'id': 'animal_names_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'animal_names',
      'zoneId': 'jungle_grove',
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['literacy', 'multisensory'],
      'lumiLineKey': 'What is this animal called?',
      'targetId': target['id'],
      'mode': 'name_match',
      'items': items,
      'relatedConcepts': ['jungle_grove.${target['id']}'],
    });
  }
  _writeJson('assets/content/learning/animals/animal_names.json', {'levels': levels});
}

void _generateTapMatch(
  String gameType,
  String zoneId,
  List<Map<String, String>> pool,
  int count, {
  String Function(String label)? promptBuilder,
  String mode = 'tap_match',
  int poolOffset = 0,
}) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final target = pool[(i + poolOffset) % pool.length];
    final wrongPool = pool.where((a) => a['id'] != target['id']).toList()
      ..shuffle(_rng);
    final items = [
      {
        'id': target['id'],
        'emoji': target['emoji'],
        'label': target['label'],
        'isCorrect': true,
      },
      ...wrongPool.take(3).map(
            (a) => {
              'id': a['id'],
              'emoji': a['emoji'],
              'label': a['label'],
              'isCorrect': false,
            },
          ),
    ]..shuffle(_rng);
    final label = target['label']!;
    levels.add({
      'id': '${gameType}_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': gameType,
      'zoneId': zoneId,
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['play_based', 'multisensory'],
      'lumiLineKey': promptBuilder?.call(label) ?? 'Find the $label!',
      'targetId': target['id'],
      'mode': mode,
      'items': items,
      'relatedConcepts': ['$zoneId.${target['id']}'],
    });
  }
  final folder = _folderForGameType(gameType);
  _writeJson('assets/content/$folder/$gameType.json', {'levels': levels});
}

String _folderForGameType(String gameType) {
  if (['number_recognition', 'counting'].contains(gameType)) {
    return 'learning/math';
  }
  if (['letter_recognition', 'letter_phonics'].contains(gameType)) {
    return 'learning/alphabet';
  }
  if (['fun_colors', 'color_recognition', 'opposites'].contains(gameType)) {
    return 'learning/colors';
  }
  if (gameType.startsWith('true_false')) return 'learning/true_false';
  if (gameType == 'which_tool_works') return 'games/tools';
  return 'learning/animals';
}

void _generateWhichToolWorks(int count) {
  final tools = [
    {'task': 'A loose screw needs tightening', 'correct': 'screwdriver', 'emoji': '🪛', 'options': ['hammer', 'wrench', 'screwdriver', 'scissors']},
    {'task': 'A nail needs hitting', 'correct': 'hammer', 'emoji': '🔨', 'options': ['hammer', 'screwdriver', 'scissors', 'ruler']},
    {'task': 'Paper needs cutting', 'correct': 'scissors', 'emoji': '✂️', 'options': ['hammer', 'scissors', 'spoon', 'brush']},
    {'task': 'A bolt needs turning', 'correct': 'wrench', 'emoji': '🔧', 'options': ['wrench', 'hammer', 'pen', 'cup']},
    {'task': 'Food needs stirring', 'correct': 'spoon', 'emoji': '🥄', 'options': ['spoon', 'saw', 'drill', 'hose']},
  ];
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final t = tools[i % tools.length];
    final options = (t['options'] as List<String>).map((id) => {
          'id': id,
          'emoji': _toolEmoji(id),
          'label': id,
          'isCorrect': id == t['correct'],
        }).toList();
    levels.add({
      'id': 'tool_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'which_tool_works',
      'zoneId': 'tools_professions',
      'levelNumber': i + 1,
      'difficulty': (i / 25).ceil(),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['inquiry', 'montessori'],
      'lumiLineKey': t['task'],
      'options': options,
      'feedback': _feedback(),
      'relatedConcepts': ['tools.${t['correct']}'],
    });
  }
  _writeJson('assets/content/games/tools/which_tool_works.json', {'levels': levels});
}

String _toolEmoji(String id) {
  const m = {'hammer': '🔨', 'screwdriver': '🪛', 'scissors': '✂️', 'wrench': '🔧', 'spoon': '🥄', 'saw': '🪚', 'drill': '🔩', 'hose': '🚿', 'ruler': '📏', 'pen': '🖊️', 'cup': '☕', 'brush': '🖌️'};
  return m[id] ?? '🔧';
}

void _generateShadowGame(int count) {
  final items = ['elephant', 'giraffe', 'car', 'house', 'apple', 'cat', 'dog', 'tree'];
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final item = items[i % items.length];
    levels.add({
      'id': 'shadow_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'shadow_game',
      'zoneId': 'puzzle_palace',
      'levelNumber': i + 1,
      'difficulty': (i / 25).ceil(),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['montessori'],
      'referenceImage': 'assets/images/games/$item.png',
      'items': [{'id': 'drag', 'emoji': '🖼️', 'label': item}],
      'bins': [
        {'id': 'correct', 'emoji': '⬛', 'label': 'Shadow', 'acceptsId': 'drag'},
        {'id': 'wrong1', 'emoji': '⬛', 'label': 'Wrong', 'acceptsId': 'wrong'},
      ],
      'relatedConcepts': ['visual.shadow.$item'],
    });
  }
  _writeJson('assets/content/games/shadow_game/levels.json', {'levels': levels});
}

void _generateTrueFalse(
  String gameType,
  String zoneId,
  List<(String, bool)> facts,
  int count,
) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final (statement, isTrue) = facts[i % facts.length];
    levels.add({
      'id': '${gameType}_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': gameType,
      'zoneId': zoneId,
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil(),
      'starsAvailable': 3,
      'scaffoldHints': 1,
      'learningMethod': ['inquiry'],
      'statementKey': statement,
      'isTrue': isTrue,
      'explanationKey': isTrue ? 'Correct!' : 'Not quite — try again next time!',
      'relatedConcepts': ['facts.$gameType'],
    });
  }
  _writeJson('assets/content/learning/true_false/$gameType.json', {'levels': levels});
}

void _generateWhatAmI(int count) {
  final riddles = [
    {'clues': ['I am yellow.', 'I grow on a tree.', 'Monkeys love me.'], 'answer': 'banana', 'choices': ['banana', 'lemon', 'star', 'duck']},
    {'clues': ['I am king of the jungle.', 'I have a mane.', 'I roar loudly.'], 'answer': 'lion', 'choices': ['lion', 'cat', 'bear', 'wolf']},
    {'clues': ['I am big and grey.', 'I have a trunk.', 'I never forget.'], 'answer': 'elephant', 'choices': ['elephant', 'mouse', 'horse', 'fish']},
    {'clues': ['I shine at night.', 'I am round.', 'Astronauts visited me.'], 'answer': 'moon', 'choices': ['moon', 'sun', 'star', 'cloud']},
    {'clues': ['I am red.', 'You eat me on pizza.', 'I am a vegetable fruit.'], 'answer': 'tomato', 'choices': ['tomato', 'apple', 'car', 'book']},
  ];
  const emojiMap = {'banana': '🍌', 'lemon': '🍋', 'star': '⭐', 'duck': '🦆', 'lion': '🦁', 'cat': '🐱', 'bear': '🐻', 'wolf': '🐺', 'elephant': '🐘', 'mouse': '🐭', 'horse': '🐴', 'fish': '🐟', 'moon': '🌙', 'sun': '☀️', 'cloud': '☁️', 'tomato': '🍅', 'apple': '🍎', 'car': '🚗', 'book': '📚'};

  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final r = riddles[i % riddles.length];
    levels.add({
      'id': 'wai_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'what_am_i',
      'zoneId': 'world_village',
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil(),
      'starsAvailable': 3,
      'scaffoldHints': 1,
      'learningMethod': ['inquiry', 'narrative'],
      'clues': r['clues'],
      'answerId': r['answer'],
      'items': (r['choices'] as List<String>).map((c) => {
            'id': c,
            'emoji': emojiMap[c] ?? '❓',
            'label': c,
          }).toList(),
      'relatedConcepts': ['riddle.${r['answer']}'],
    });
  }
  _writeJson('assets/content/games/what_am_i/riddles.json', {'levels': levels});
}

void _generateBuildScene() {
  final scenes = [
    {'id': 'farm', 'emoji': '🌾', 'items': ['🐄', '🐔', '🚜', '🏚️', '🌻']},
    {'id': 'ocean', 'emoji': '🌊', 'items': ['🐟', '⛵', '🐋', '🏖️', '🦀']},
    {'id': 'city', 'emoji': '🌆', 'items': ['🏢', '🚗', '🌳', '🚦', '🏪']},
    {'id': 'jungle', 'emoji': '🌳', 'items': ['🦁', '🐒', '🦜', '🌴', '🐍']},
    {'id': 'space', 'emoji': '🚀', 'items': ['🪐', '👨‍🚀', '⭐', '🛸', '🌙']},
    {'id': 'beach', 'emoji': '🏖️', 'items': ['🏖️', '🦀', '⛱️', '🐚', '🏄']},
  ];
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < scenes.length; i++) {
    final s = scenes[i];
    for (var mode = 1; mode <= 3; mode++) {
      levels.add({
        'id': 'scene_${s['id']}_$mode',
        'gameType': 'build_scene',
        'zoneId': 'world_village',
        'levelNumber': i * 3 + mode,
        'difficulty': mode,
        'starsAvailable': 3,
        'scaffoldHints': 0,
        'learningMethod': ['play_based'],
        'backgroundImage': s['emoji'],
        'itemTray': (s['items'] as List<String>).map((e) => {'id': e, 'emoji': e}).toList(),
        'relatedConcepts': ['scene.${s['id']}'],
      });
    }
  }
  _writeJson('assets/content/games/build_scene/scenes.json', {'levels': levels});
}

void _generateFunFacts(int count) {
  final facts = [
    {'id': 'f1', 'factKey': 'facts.elephant.mirror', 'category': 'animals', 'ageMin': 3},
    {'id': 'f2', 'factKey': 'facts.dino.trex_arms', 'category': 'dinosaurs', 'ageMin': 4},
    {'id': 'f3', 'factKey': 'facts.space.sun_star', 'category': 'space', 'ageMin': 4},
    {'id': 'f4', 'factKey': 'facts.cow.moo', 'category': 'animals', 'ageMin': 2},
    {'id': 'f5', 'factKey': 'facts.bee.honey', 'category': 'animals', 'ageMin': 3},
    {'id': 'f6', 'factKey': 'facts.ocean.deep', 'category': 'nature', 'ageMin': 5},
  ];
  final list = List.generate(count, (i) {
    final f = facts[i % facts.length];
    return {
      ...f,
      'id': 'f${i + 1}',
      'relatedConcepts': ['fact.${f['category']}'],
    };
  });
  _writeJson('assets/content/fun_facts/facts.json', list);
}

void _generateBadges() {
  _writeJson('assets/content/rewards/badges.json', [
    {'id': 'animal_expert', 'nameKey': 'badge.animal_expert', 'descriptionKey': 'badge.animal_expert.desc', 'icon': 'paw', 'unlockRule': {'type': 'levels', 'zone': 'jungle_grove', 'count': 10}},
    {'id': 'color_master', 'nameKey': 'badge.color_master', 'descriptionKey': 'badge.color_master.desc', 'icon': 'palette', 'unlockRule': {'type': 'drawing', 'count': 5}},
    {'id': 'number_wizard', 'nameKey': 'badge.number_wizard', 'descriptionKey': 'badge.number_wizard.desc', 'icon': 'numbers', 'unlockRule': {'type': 'levels', 'zone': 'number_mountain', 'count': 10}},
    {'id': 'letter_hero', 'nameKey': 'badge.letter_hero', 'descriptionKey': 'badge.letter_hero.desc', 'icon': 'abc', 'unlockRule': {'type': 'levels', 'zone': 'letter_lane', 'count': 10}},
    {'id': 'dino_explorer', 'nameKey': 'badge.dino_explorer', 'descriptionKey': 'badge.dino_explorer.desc', 'icon': 'dino', 'unlockRule': {'type': 'levels', 'zone': 'dinosaurs', 'count': 25}},
    {'id': 'space_pilot', 'nameKey': 'badge.space_pilot', 'descriptionKey': 'badge.space_pilot.desc', 'icon': 'rocket', 'unlockRule': {'type': 'levels', 'zone': 'space_science', 'count': 25}},
    {'id': 'puzzle_master', 'nameKey': 'badge.puzzle_master', 'descriptionKey': 'badge.puzzle_master.desc', 'icon': 'puzzle', 'unlockRule': {'type': 'levels', 'gameType': 'complete_picture', 'count': 50}},
  ]);
}

void _generateStickers() {
  _writeJson('assets/content/rewards/stickers.json', [
    {'id': 'animal_world', 'nameKey': 'album.animal_world', 'icon': 'paw', 'slots': 50, 'unlockRule': {'type': 'free'}},
    {'id': 'dinosaur_world', 'nameKey': 'album.dinosaur_world', 'icon': 'dino', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'dinosaurs', 'count': 25}},
    {'id': 'space_explorers', 'nameKey': 'album.space_explorers', 'icon': 'rocket', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'space_science', 'count': 25}},
    {'id': 'number_wizards', 'nameKey': 'album.number_wizards', 'icon': 'numbers', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'number_mountain', 'count': 20}},
    {'id': 'letter_heroes', 'nameKey': 'album.letter_heroes', 'icon': 'abc', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'letter_lane', 'count': 26}},
    {'id': 'color_masters', 'nameKey': 'album.color_masters', 'icon': 'palette', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'color_canyon', 'count': 20}},
    {'id': 'world_travelers', 'nameKey': 'album.world_travelers', 'icon': 'globe', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'world_village', 'count': 30}},
    {'id': 'music_makers', 'nameKey': 'album.music_makers', 'icon': 'music', 'slots': 50, 'unlockRule': {'type': 'levels', 'zone': 'music_meadow', 'count': 10}},
  ]);
}

void _generateLocalization() {
  _writeJson('assets/content/localization/en.json', {
    'zone.jungle_grove': 'Jungle Grove',
    'zone.number_mountain': 'Number Mountain',
    'zone.letter_lane': 'Letter Lane',
    'zone.color_canyon': 'Color Canyon',
    'zone.dinosaurs': 'Dinosaur Zone',
    'zone.space_science': 'Space Zone',
    'zone.tools_professions': 'Tools Zone',
    'zone.sports_body': 'Sports Zone',
    'zone.seasons_holidays': 'Seasons Zone',
    'zone.household_daily': 'Household Zone',
    'lumi.complete_picture.hint': 'Find the missing piece!',
    'badge.animal_expert': 'Animal Expert',
    'badge.color_master': 'Color Master',
    'badge.dino_explorer': 'Dinosaur Explorer',
    'album.animal_world': 'Animal World',
  });
  _writeJson('assets/content/localization/ur.json', {
    'zone.jungle_grove': 'جنگل گROVE',
    'zone.number_mountain': 'نمبر ماؤنٹین',
    'zone.letter_lane': 'لیٹر لین',
    'zone.dinosaurs': 'ڈائنوسور زون',
    'lumi.complete_picture.hint': 'غائب ٹukra تلاش کرو!',
  });
}

void _generateManifest() {
  final cpPaths = List.generate(
    5,
    (b) {
      final s = b * 100 + 1;
      final e = b * 100 + 100;
      return 'assets/content/games/complete_picture/levels_${s.toString().padLeft(3, '0')}_${e.toString().padLeft(3, '0')}.json';
    },
  );

  final registry = <String, dynamic>{
    'complete_picture': {'mechanic': 'select_piece', 'minLevels': 500, 'contentPaths': cpPaths},
    'animal_world': {'mechanic': 'tap_match', 'minLevels': 80, 'contentPaths': ['assets/content/learning/animals/animal_world.json']},
    'animal_names': {'mechanic': 'name_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/animals/animal_names.json']},
    'number_recognition': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/math/number_recognition.json']},
    'counting': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/math/counting.json']},
    'letter_recognition': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/alphabet/letter_recognition.json']},
    'letter_phonics': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/alphabet/letter_phonics.json']},
    'dino_names': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/animals/dino_names.json']},
    'space_objects': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/animals/space_objects.json']},
    'sports_names': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/animals/sports_names.json']},
    'four_seasons': {'mechanic': 'tap_match', 'minLevels': 80, 'contentPaths': ['assets/content/learning/animals/four_seasons.json']},
    'household_items': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/animals/household_items.json']},
    'fun_colors': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/colors/fun_colors.json']},
    'color_recognition': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/colors/color_recognition.json']},
    'opposites': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/colors/opposites.json']},
    'shadow_game': {'mechanic': 'drag_drop', 'minLevels': 100, 'contentPaths': ['assets/content/games/shadow_game/levels.json']},
    'what_am_i': {'mechanic': 'riddle', 'minLevels': 80, 'contentPaths': ['assets/content/games/what_am_i/riddles.json']},
    'build_scene': {'mechanic': 'sandbox', 'minLevels': 18, 'contentPaths': ['assets/content/games/build_scene/scenes.json']},
    'which_tool_works': {'mechanic': 'select_piece', 'minLevels': 100, 'contentPaths': ['assets/content/games/tools/which_tool_works.json']},
    'true_false_animals': {'mechanic': 'true_false', 'minLevels': 100, 'contentPaths': ['assets/content/learning/true_false/true_false_animals.json']},
    'true_false_dino': {'mechanic': 'true_false', 'minLevels': 80, 'contentPaths': ['assets/content/learning/true_false/true_false_dino.json']},
    'true_false_space': {'mechanic': 'true_false', 'minLevels': 80, 'contentPaths': ['assets/content/learning/true_false/true_false_space.json']},
  };

  final manifest = {
    'version': '3.0.0',
    'contentVersion': 2,
    'totalLevels': 3500,
    'zones': _buildZones(),
    'gameTypeRegistry': registry,
  };
  _writeJson('assets/content/manifest.json', manifest);
}

List<Map<String, dynamic>> _buildZones() {
  return [
    {'id': 'jungle_grove', 'nameKey': 'zone.jungle_grove', 'levelCount': 600, 'gameTypes': ['animal_names', 'animal_world'], 'palette': {'primary': '#4CAF50', 'accent': '#FF9800'}, 'unlockStars': 0, 'isFree': true, 'positionX': 0.2, 'positionY': 0.7},
    {'id': 'number_mountain', 'nameKey': 'zone.number_mountain', 'levelCount': 600, 'gameTypes': ['number_recognition', 'counting'], 'palette': {'primary': '#5C6BC0', 'accent': '#FF7043'}, 'unlockStars': 0, 'isFree': true, 'positionX': 0.5, 'positionY': 0.15},
    {'id': 'letter_lane', 'nameKey': 'zone.letter_lane', 'levelCount': 600, 'gameTypes': ['letter_recognition', 'letter_phonics'], 'palette': {'primary': '#AB47BC', 'accent': '#26C6DA'}, 'unlockStars': 0, 'isFree': true, 'positionX': 0.8, 'positionY': 0.15},
    {'id': 'color_canyon', 'nameKey': 'zone.color_canyon', 'levelCount': 600, 'gameTypes': ['color_recognition', 'fun_colors'], 'palette': {'primary': '#EC407A', 'accent': '#FFCA28'}, 'unlockStars': 50, 'isFree': false, 'positionX': 0.5, 'positionY': 0.55},
    {'id': 'puzzle_palace', 'nameKey': 'zone.puzzle_palace', 'levelCount': 500, 'gameTypes': ['complete_picture', 'shadow_game'], 'palette': {'primary': '#7E57C2', 'accent': '#26A69A'}, 'unlockStars': 75, 'isFree': false, 'positionX': 0.85, 'positionY': 0.55},
    {'id': 'world_village', 'nameKey': 'zone.world_village', 'levelCount': 600, 'gameTypes': ['what_am_i', 'build_scene', 'true_false_animals'], 'palette': {'primary': '#00897B', 'accent': '#FFB300'}, 'unlockStars': 100, 'isFree': false, 'positionX': 0.75, 'positionY': 0.75},
    {'id': 'music_meadow', 'nameKey': 'zone.music_meadow', 'levelCount': 150, 'gameTypes': ['simon_says'], 'palette': {'primary': '#D81B60', 'accent': '#8E24AA'}, 'unlockStars': 60, 'isFree': false, 'positionX': 0.15, 'positionY': 0.15},
    {'id': 'opposites_ocean', 'nameKey': 'zone.opposites_ocean', 'levelCount': 530, 'gameTypes': ['opposites'], 'palette': {'primary': '#039BE5', 'accent': '#00ACC1'}, 'unlockStars': 80, 'isFree': false, 'positionX': 0.65, 'positionY': 0.4},
    {'id': 'dinosaurs', 'nameKey': 'zone.dinosaurs', 'levelCount': 520, 'gameTypes': ['dino_names', 'true_false_dino'], 'palette': {'primary': '#795548', 'accent': '#FF8F00'}, 'unlockStars': 25, 'isFree': true, 'positionX': 0.85, 'positionY': 0.25},
    {'id': 'space_science', 'nameKey': 'zone.space_science', 'levelCount': 520, 'gameTypes': ['space_objects', 'true_false_space'], 'palette': {'primary': '#283593', 'accent': '#7E57C2'}, 'unlockStars': 50, 'isFree': false, 'positionX': 0.95, 'positionY': 0.1},
    {'id': 'tools_professions', 'nameKey': 'zone.tools_professions', 'levelCount': 520, 'gameTypes': ['which_tool_works'], 'palette': {'primary': '#546E7A', 'accent': '#FF7043'}, 'unlockStars': 40, 'isFree': false, 'positionX': 0.35, 'positionY': 0.85, 'isSecret': true},
    {'id': 'sports_body', 'nameKey': 'zone.sports_body', 'levelCount': 520, 'gameTypes': ['sports_names'], 'palette': {'primary': '#E53935', 'accent': '#1E88E5'}, 'unlockStars': 90, 'isFree': false, 'positionX': 0.9, 'positionY': 0.85},
    {'id': 'seasons_holidays', 'nameKey': 'zone.seasons_holidays', 'levelCount': 520, 'gameTypes': ['four_seasons'], 'palette': {'primary': '#43A047', 'accent': '#FB8C00'}, 'unlockStars': 70, 'isFree': false, 'positionX': 0.55, 'positionY': 0.85},
    {'id': 'household_daily', 'nameKey': 'zone.household_daily', 'levelCount': 520, 'gameTypes': ['household_items'], 'palette': {'primary': '#6D4C41', 'accent': '#FFA726'}, 'unlockStars': 65, 'isFree': false, 'positionX': 0.7, 'positionY': 0.65},
    {'id': 'drawing_den', 'nameKey': 'zone.drawing_den', 'levelCount': 250, 'gameTypes': ['coloring', 'free_draw'], 'palette': {'primary': '#42A5F5', 'accent': '#FF7043'}, 'unlockStars': 10, 'isFree': true, 'positionX': 0.1, 'positionY': 0.5, 'isSecret': true},
  ];
}
