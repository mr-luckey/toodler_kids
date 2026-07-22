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
  _generateNumberRecognition(100);
  _generateCounting(100);
  _generateLetterRecognition(100);
  _generateLetterPhonics(100);
  _generateColorRecognition(100);
  _generateFunColors(100);
  _generateTapMatch('dino_names', 'dinosaurs', _dinos, _dinos.length);
  _generateTapMatch('space_objects', 'space_science', _space, _space.length);
  _generateTapMatch('sports_names', 'sports_body', _sports, _sports.length);
  _generateTapMatch('four_seasons', 'seasons_holidays', _seasons, _seasons.length);
  _generateTapMatch('household_items', 'household_daily', _household, _household.length);
  _generateOpposites();
  _generateWhichToolWorks();
  _generateShadowGame();
  _generateTrueFalse('true_false_animals', 'jungle_grove', _tfAnimals, _tfAnimals.length);
  _generateTrueFalse('true_false_dino', 'dinosaurs', _tfDino, _tfDino.length);
  _generateTrueFalse('true_false_space', 'space_science', _tfSpace, _tfSpace.length);
  _generateTrueFalse('true_false_world', 'world_village', _tfWorld, _tfWorld.length);
  _generateWhatAmI();
  _generateSimonSays(50);
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
  {'id': 'astronaut', 'emoji': '👨‍🚀', 'label': 'Astronaut'},
  {'id': 'ufo', 'emoji': '🛸', 'label': 'UFO'},
  {'id': 'jupiter', 'emoji': '🟤', 'label': 'Jupiter'},
  {'id': 'venus', 'emoji': '🟡', 'label': 'Venus'},
  {'id': 'neptune', 'emoji': '🔵', 'label': 'Neptune'},
  {'id': 'galaxy', 'emoji': '🌌', 'label': 'Galaxy'},
  {'id': 'asteroid', 'emoji': '☄️', 'label': 'Asteroid'},
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
  {'id': 'spring_flowers', 'emoji': '🌸', 'label': 'Spring Flowers'},
  {'id': 'spring_rain', 'emoji': '🌧️', 'label': 'Spring Rain'},
  {'id': 'summer_sun', 'emoji': '☀️', 'label': 'Summer Sun'},
  {'id': 'summer_beach', 'emoji': '🏖️', 'label': 'Summer Beach'},
  {'id': 'autumn_leaves', 'emoji': '🍂', 'label': 'Autumn Leaves'},
  {'id': 'autumn_pumpkin', 'emoji': '🎃', 'label': 'Autumn Pumpkin'},
  {'id': 'winter_snow', 'emoji': '❄️', 'label': 'Winter Snow'},
  {'id': 'winter_snowman', 'emoji': '☃️', 'label': 'Winter Snowman'},
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

final _oppositePairs = [
  {'a': 'big', 'aEmoji': '🐘', 'aLabel': 'Big', 'b': 'small', 'bEmoji': '🐜', 'bLabel': 'Small'},
  {'a': 'hot', 'aEmoji': '🔥', 'aLabel': 'Hot', 'b': 'cold', 'bEmoji': '❄️', 'bLabel': 'Cold'},
  {'a': 'fast', 'aEmoji': '🐆', 'aLabel': 'Fast', 'b': 'slow', 'bEmoji': '🐢', 'bLabel': 'Slow'},
  {'a': 'up', 'aEmoji': '⬆️', 'aLabel': 'Up', 'b': 'down', 'bEmoji': '⬇️', 'bLabel': 'Down'},
  {'a': 'day', 'aEmoji': '☀️', 'aLabel': 'Day', 'b': 'night', 'bEmoji': '🌙', 'bLabel': 'Night'},
  {'a': 'happy', 'aEmoji': '😊', 'aLabel': 'Happy', 'b': 'sad', 'bEmoji': '😢', 'bLabel': 'Sad'},
  {'a': 'loud', 'aEmoji': '🔊', 'aLabel': 'Loud', 'b': 'quiet', 'bEmoji': '🤫', 'bLabel': 'Quiet'},
  {'a': 'open', 'aEmoji': '🚪', 'aLabel': 'Open', 'b': 'closed', 'bEmoji': '🔒', 'bLabel': 'Closed'},
  {'a': 'full', 'aEmoji': '🪣', 'aLabel': 'Full', 'b': 'empty', 'bEmoji': '📭', 'bLabel': 'Empty'},
  {'a': 'wet', 'aEmoji': '💧', 'aLabel': 'Wet', 'b': 'dry', 'bEmoji': '🏜️', 'bLabel': 'Dry'},
  {'a': 'clean', 'aEmoji': '✨', 'aLabel': 'Clean', 'b': 'dirty', 'bEmoji': '🟤', 'bLabel': 'Dirty'},
  {'a': 'young', 'aEmoji': '👶', 'aLabel': 'Young', 'b': 'old', 'bEmoji': '👴', 'bLabel': 'Old'},
  {'a': 'light', 'aEmoji': '💡', 'aLabel': 'Light', 'b': 'dark', 'bEmoji': '🌑', 'bLabel': 'Dark'},
  {'a': 'tall', 'aEmoji': '🦒', 'aLabel': 'Tall', 'b': 'short', 'bEmoji': '🐕', 'bLabel': 'Short'},
  {'a': 'hard', 'aEmoji': '🪨', 'aLabel': 'Hard', 'b': 'soft', 'bEmoji': '🛏️', 'bLabel': 'Soft'},
  {'a': 'near', 'aEmoji': '👋', 'aLabel': 'Near', 'b': 'far', 'bEmoji': '🔭', 'bLabel': 'Far'},
  {'a': 'inside', 'aEmoji': '🏠', 'aLabel': 'Inside', 'b': 'outside', 'bEmoji': '🌳', 'bLabel': 'Outside'},
  {'a': 'give', 'aEmoji': '🎁', 'aLabel': 'Give', 'b': 'take', 'bEmoji': '🤲', 'bLabel': 'Take'},
  {'a': 'push', 'aEmoji': '👐', 'aLabel': 'Push', 'b': 'pull', 'bEmoji': '🧲', 'bLabel': 'Pull'},
  {'a': 'awake', 'aEmoji': '😃', 'aLabel': 'Awake', 'b': 'asleep', 'bEmoji': '😴', 'bLabel': 'Asleep'},
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
  ('Earth goes around the Sun.', true),
  ('Stars are huge balls of hot gas.', true),
  ('Astronauts wear space suits.', true),
  ('Comets are made of ice and rock.', true),
  ('Jupiter is the smallest planet.', false),
  ('There is no gravity in space.', false),
  ('Rockets help us travel to space.', true),
  ('The Milky Way is our galaxy.', true),
  ('Venus is hotter than Mercury.', true),
  ('Neptune is a blue planet.', true),
  ('UFOs are proven alien spaceships.', false),
  ('Shooting stars are meteors.', true),
  ('The Sun rises in the east.', true),
  ('You can hear sound in space.', false),
  ('Earth is mostly covered by water.', true),
];

final _tfWorld = [
  ('The Eiffel Tower is in France.', true),
  ('Pizza originally comes from Italy.', true),
  ('Kangaroos live in Australia.', true),
  ('The Great Wall is in China.', true),
  ('Pyramids are found in Egypt.', true),
  ('Tokyo is a city in Japan.', true),
  ('The Statue of Liberty is in New York.', true),
  ('Penguins live at the North Pole.', false),
  ('Camels are called ships of the desert.', true),
  ('The Sahara is a hot desert.', true),
  ('India is famous for spicy curry.', true),
  ('Soccer is popular around the world.', true),
  ('Mount Everest is the tallest mountain.', true),
  ('Brazil is famous for samba dance.', true),
  ('The Nile is a long river in Africa.', true),
  ('Canada is south of the USA.', false),
  ('Baguettes are a bread from France.', true),
  ('Lions live wild in India too.', true),
  ('The Amazon is a rainforest.', true),
  ('Mexico is famous for tacos.', true),
  ('London is the capital of England.', true),
  ('Polar bears live in the Arctic.', true),
  ('Rice is eaten in many Asian countries.', true),
  ('The Taj Mahal is in India.', true),
  ('Hawaii is part of the United States.', true),
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

/// Every PNG id under assets/images/game/ — 99 unique puzzle pictures.
List<String> _allPuzzleImageIds() => [
      'lion', 'elephant', 'giraffe', 'monkey', 'cow', 'sheep', 'pig',
      'chicken', 'horse', 'duck', 'frog', 'bear', 'penguin', 'shark', 'butterfly',
      'trex', 'triceratops', 'stego', 'brachio', 'veloci', 'ptero', 'ankylo', 'spino',
      'sun', 'moon', 'earth', 'mars', 'rocket', 'saturn', 'star', 'comet',
      'football', 'basketball', 'tennis', 'swimming', 'cricket', 'golf', 'skiing',
      'hammer', 'wrench', 'screwdriver', 'saw', 'drill', 'pliers',
      'red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'black', 'white',
      for (var n = 1; n <= 20; n++) 'num_$n',
      for (final l in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) 'letter_$l',
    ];

/// 500 unique (image, colorVariant) pairs — no exact puzzle repeats.
List<({String theme, int colorVariant})> _buildUniquePuzzleAssignments() {
  final pool = _allPuzzleImageIds();
  final assignments = <({String theme, int colorVariant})>[];
  var variant = 0;
  while (assignments.length < 500) {
    final shuffled = List<String>.from(pool)..shuffle(_rng);
    for (final theme in shuffled) {
      if (assignments.length >= 500) break;
      assignments.add((theme: theme, colorVariant: variant));
    }
    variant++;
  }
  return assignments;
}

void _generateCompletePicture500() {
  final assignments = _buildUniquePuzzleAssignments();
  final pool = _allPuzzleImageIds();
  for (var batch = 0; batch < 5; batch++) {
    final levels = <Map<String, dynamic>>[];
    for (var i = 1; i <= 100; i++) {
      final num = batch * 100 + i;
      final assignment = assignments[num - 1];
      final theme = assignment.theme;
      final colorVariant = assignment.colorVariant;
      final choiceCount = num <= 100 ? 2 : (num <= 300 ? 3 : 4);
      final options = <Map<String, dynamic>>[
        {
          'id': 'correct',
          'image': 'assets/images/game/$theme.png',
          'isCorrect': true,
        },
      ];
      for (var j = 1; j < choiceCount; j++) {
        final wrongTheme = pool[(pool.indexOf(theme) + j * 7) % pool.length];
        options.add({
          'id': 'wrong_$j',
          'image': 'assets/images/game/$wrongTheme.png',
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
        'prompt': {
          'type': 'none',
          'lumiLineKey': 'Find the missing piece! 🧩',
        },
        'referenceImage': 'assets/images/game/$theme.png',
        'board': {'gridRows': 3, 'gridCols': 3, 'missingSlots': [{'row': 1, 'col': 1}]},
        'options': options,
        'feedback': _feedback(),
        'funFactKey': num % 3 == 0 ? 'facts.$theme.default' : null,
        'relatedConcepts': ['visual.complete.$theme'],
        'extra': {'colorVariant': colorVariant},
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

void _generateNumberRecognition(int count) {
  _generateTapMatch(
    'number_recognition',
    'number_mountain',
    _numbers,
    count,
    promptBuilder: (label) => 'Find the number $label!',
    mode: 'tap_match',
    poolOffset: 0,
  );
}

void _generateCounting(int count) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final target = _numbers[(i + 3) % _numbers.length];
    final n = int.parse(target['label']!);
    final wrongPool = _numbers.where((a) => a['id'] != target['id']).toList()
      ..shuffle(_rng);
    final items = [
      {'id': target['id'], 'label': target['label'], 'isCorrect': true},
      ...wrongPool.take(3).map(
            (a) => {
              'id': a['id'],
              'label': a['label'],
              'isCorrect': false,
            },
          ),
    ]..shuffle(_rng);
    levels.add({
      'id': 'counting_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'counting',
      'zoneId': 'number_mountain',
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['math', 'multisensory'],
      'lumiLineKey': 'How many do you see?',
      'targetId': target['id'],
      'mode': 'count_match',
      'countVisual': n,
      'countEmoji': '⭐',
      'items': items,
      'relatedConcepts': ['number_mountain.${target['id']}'],
    });
  }
  _writeJson('assets/content/learning/math/counting.json', {'levels': levels});
}

void _generateLetterRecognition(int count) {
  _generateTapMatch(
    'letter_recognition',
    'letter_lane',
    _letters,
    count,
    promptBuilder: (label) => 'Find the letter $label!',
    mode: 'tap_match',
    poolOffset: 0,
  );
}

void _generateLetterPhonics(int count) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final target = _letters[(i + 7) % _letters.length];
    final wrongPool = _letters.where((a) => a['id'] != target['id']).toList()
      ..shuffle(_rng);
    final items = [
      {'id': target['id'], 'label': target['label'], 'isCorrect': true},
      ...wrongPool.take(3).map(
            (a) => {
              'id': a['id'],
              'label': a['label'],
              'isCorrect': false,
            },
          ),
    ]..shuffle(_rng);
    final letter = target['label']!;
    levels.add({
      'id': 'letter_phonics_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'letter_phonics',
      'zoneId': 'letter_lane',
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['phonics', 'multisensory'],
      'lumiLineKey': 'Which letter says /${letter.toLowerCase()}/?',
      'targetId': target['id'],
      'mode': 'phonics_match',
      'phonicsSound': '/${letter.toLowerCase()}/',
      'items': items,
      'relatedConcepts': ['letter_lane.${target['id']}'],
    });
  }
  _writeJson('assets/content/learning/alphabet/letter_phonics.json', {'levels': levels});
}

void _generateColorRecognition(int count) {
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final target = _colors[(i + 2) % _colors.length];
    final wrongPool = _colors.where((a) => a['id'] != target['id']).toList()
      ..shuffle(_rng);
    final items = [
      {'id': target['id'], 'label': target['label'], 'isCorrect': true},
      ...wrongPool.take(3).map(
            (a) => {
              'id': a['id'],
              'label': a['label'],
              'isCorrect': false,
            },
          ),
    ]..shuffle(_rng);
    levels.add({
      'id': 'color_recognition_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'color_recognition',
      'zoneId': 'color_canyon',
      'levelNumber': i + 1,
      'difficulty': (i / 20).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['literacy', 'multisensory'],
      'lumiLineKey': 'What color is this?',
      'targetId': target['id'],
      'mode': 'color_name',
      'items': items,
      'relatedConcepts': ['color_canyon.${target['id']}'],
    });
  }
  _writeJson('assets/content/learning/colors/color_recognition.json', {'levels': levels});
}

void _generateFunColors(int count) {
  _generateTapMatch(
    'fun_colors',
    'color_canyon',
    _colors,
    count,
    promptBuilder: (label) => 'Tap the $label color!',
    mode: 'quick_tap',
    poolOffset: 4,
  );
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

void _generateOpposites() {
  final allLabels = <String, String>{};
  for (final pair in _oppositePairs) {
    allLabels[pair['a'] as String] = pair['aLabel'] as String;
    allLabels[pair['b'] as String] = pair['bLabel'] as String;
  }

  final levels = <Map<String, dynamic>>[];
  var i = 0;
  for (final pair in _oppositePairs) {
    final rounds = [
      (pair['a'], pair['aEmoji'], pair['aLabel'], pair['b'], pair['bLabel']),
      (pair['b'], pair['bEmoji'], pair['bLabel'], pair['a'], pair['aLabel']),
    ];
    for (final round in rounds) {
      i++;
      final srcId = round.$1 as String;
      final srcEmoji = round.$2 as String;
      final srcLabel = round.$3 as String;
      final ansId = round.$4 as String;
      final ansLabel = round.$5 as String;

      final wrongIds = allLabels.keys
          .where((id) => id != ansId && id != srcId)
          .toList()
        ..shuffle(_rng);

      final items = [
        {'id': ansId, 'label': ansLabel, 'isCorrect': true},
        ...wrongIds.take(3).map(
              (id) => {
                'id': id,
                'label': allLabels[id],
                'isCorrect': false,
              },
            ),
      ]..shuffle(_rng);

      levels.add({
        'id': 'opposites_${i.toString().padLeft(3, '0')}',
        'gameType': 'opposites',
        'zoneId': 'opposites_ocean',
        'levelNumber': i,
        'difficulty': (i / 10).ceil().clamp(1, 5),
        'starsAvailable': 3,
        'scaffoldHints': 2,
        'learningMethod': ['inquiry', 'play_based'],
        'lumiLineKey': 'What is the OPPOSITE of $srcLabel?',
        'targetId': srcId,
        'answerId': ansId,
        'mode': 'opposite_match',
        'items': items,
        'sourceDisplay': {'id': srcId, 'emoji': srcEmoji, 'label': srcLabel},
        'relatedConcepts': ['opposites_ocean.$srcId.$ansId'],
      });
    }
  }
  _writeJson('assets/content/learning/colors/opposites.json', {'levels': levels});
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

void _generateWhichToolWorks() {
  final tools = [
    {'task': 'A loose screw needs tightening', 'correct': 'screwdriver', 'options': ['hammer', 'wrench', 'screwdriver', 'scissors']},
    {'task': 'A nail needs hitting into wood', 'correct': 'hammer', 'options': ['hammer', 'screwdriver', 'scissors', 'ruler']},
    {'task': 'Paper needs cutting', 'correct': 'scissors', 'options': ['hammer', 'scissors', 'spoon', 'brush']},
    {'task': 'A bolt needs turning', 'correct': 'wrench', 'options': ['wrench', 'hammer', 'pen', 'cup']},
    {'task': 'Soup needs stirring', 'correct': 'spoon', 'options': ['spoon', 'saw', 'drill', 'hose']},
    {'task': 'Wood needs sawing', 'correct': 'saw', 'options': ['saw', 'spoon', 'scissors', 'ruler']},
    {'task': 'A hole needs drilling', 'correct': 'drill', 'options': ['drill', 'hammer', 'brush', 'cup']},
    {'task': 'A line needs measuring', 'correct': 'ruler', 'options': ['ruler', 'wrench', 'spoon', 'hose']},
    {'task': 'A wall needs painting', 'correct': 'brush', 'options': ['brush', 'saw', 'scissors', 'drill']},
    {'task': 'Plants need watering', 'correct': 'hose', 'options': ['hose', 'hammer', 'ruler', 'pen']},
    {'task': 'A letter needs writing', 'correct': 'pen', 'options': ['pen', 'saw', 'wrench', 'hose']},
    {'task': 'A picture needs hanging', 'correct': 'hammer', 'options': ['hammer', 'spoon', 'pen', 'hose']},
    {'task': 'A pipe needs fixing', 'correct': 'wrench', 'options': ['wrench', 'brush', 'scissors', 'cup']},
    {'task': 'Fabric needs cutting', 'correct': 'scissors', 'options': ['scissors', 'drill', 'ruler', 'hose']},
    {'task': 'Cereal needs eating', 'correct': 'spoon', 'options': ['spoon', 'saw', 'hammer', 'drill']},
    {'task': 'A shelf needs a nail', 'correct': 'hammer', 'options': ['hammer', 'pen', 'spoon', 'hose']},
    {'task': 'A toy needs fixing with a screw', 'correct': 'screwdriver', 'options': ['screwdriver', 'brush', 'cup', 'hose']},
    {'task': 'A garden fence needs a plank cut', 'correct': 'saw', 'options': ['saw', 'spoon', 'pen', 'cup']},
    {'task': 'A birthday card needs decorating', 'correct': 'brush', 'options': ['brush', 'wrench', 'drill', 'hose']},
    {'task': 'How long is this table?', 'correct': 'ruler', 'options': ['ruler', 'hammer', 'spoon', 'scissors']},
    {'task': 'The car is dirty — wash it!', 'correct': 'hose', 'options': ['hose', 'pen', 'scissors', 'ruler']},
    {'task': 'Draw a circle on paper', 'correct': 'pen', 'options': ['pen', 'hammer', 'saw', 'wrench']},
    {'task': 'Tighten the bike wheel nut', 'correct': 'wrench', 'options': ['wrench', 'brush', 'spoon', 'ruler']},
    {'task': 'Make a hole for a screw', 'correct': 'drill', 'options': ['drill', 'scissors', 'cup', 'spoon']},
    {'task': 'Cut wrapping paper for a gift', 'correct': 'scissors', 'options': ['scissors', 'hose', 'drill', 'hammer']},
  ];
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < tools.length; i++) {
    final t = tools[i];
    final options = (t['options'] as List<String>).map((id) => {
          'id': id,
          'emoji': _toolEmoji(id),
          'label': _capitalize(id),
          'isCorrect': id == t['correct'],
        }).toList()
      ..shuffle(_rng);
    levels.add({
      'id': 'tool_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'which_tool_works',
      'zoneId': 'tools_professions',
      'levelNumber': i + 1,
      'difficulty': (i / 8).ceil().clamp(1, 4),
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

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

String _toolEmoji(String id) {
  const m = {'hammer': '🔨', 'screwdriver': '🪛', 'scissors': '✂️', 'wrench': '🔧', 'spoon': '🥄', 'saw': '🪚', 'drill': '🔩', 'hose': '🚿', 'ruler': '📏', 'pen': '🖊️', 'cup': '☕', 'brush': '🖌️'};
  return m[id] ?? '🔧';
}

void _generateShadowGame() {
  const items = [
    'lion', 'elephant', 'giraffe', 'monkey', 'cow', 'sheep', 'pig', 'chicken',
    'horse', 'duck', 'frog', 'bear', 'penguin', 'shark', 'butterfly',
    'trex', 'triceratops', 'stego', 'brachio', 'ptero', 'ankylo', 'spino',
    'sun', 'moon', 'earth', 'mars', 'rocket', 'saturn', 'star', 'comet',
    'astronaut', 'ufo', 'jupiter', 'venus', 'neptune', 'galaxy', 'asteroid',
    'football', 'basketball', 'tennis', 'swimming', 'cricket', 'golf', 'skiing',
    'hammer', 'wrench', 'screwdriver', 'saw', 'drill', 'pliers',
    'red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink',
  ];
  const levelCount = 100;
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < levelCount; i++) {
    final item = items[i % items.length];
    var decoy = items[(i + 17) % items.length];
    if (decoy == item) {
      decoy = items[(i + 31) % items.length];
    }
    levels.add({
      'id': 'shadow_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'shadow_game',
      'zoneId': 'puzzle_palace',
      'levelNumber': i + 1,
      'difficulty': (i / 25).floor(),
      'starsAvailable': 3,
      'scaffoldHints': 2,
      'learningMethod': ['montessori'],
      'referenceImage': 'assets/images/game/$item.png',
      'items': [
        {'id': 'drag', 'emoji': _shadowEmoji(item), 'label': item},
      ],
      'bins': [
        {'id': 'correct', 'emoji': '⬛', 'label': 'Shadow', 'acceptsId': 'drag'},
        {
          'id': 'wrong1',
          'emoji': '⬛',
          'label': 'Wrong',
          'acceptsId': 'wrong',
          'decoyId': decoy,
        },
      ],
      'relatedConcepts': ['visual.shadow.$item'],
    });
  }
  _writeJson('assets/content/games/shadow_game/levels.json', {'levels': levels});
}

String _shadowEmoji(String id) {
  const map = {
    'lion': '🦁', 'elephant': '🐘', 'giraffe': '🦒', 'monkey': '🐵', 'cow': '🐄',
    'sheep': '🐑', 'pig': '🐖', 'chicken': '🐓', 'horse': '🐴', 'duck': '🦆',
    'frog': '🐸', 'bear': '🐻', 'penguin': '🐧', 'shark': '🦈', 'butterfly': '🦋',
    'trex': '🦖', 'triceratops': '🦕', 'stego': '🦴', 'brachio': '🦕', 'ptero': '🦅',
    'ankylo': '🦴', 'spino': '🦖', 'sun': '☀️', 'moon': '🌙', 'earth': '🌍',
    'mars': '🔴', 'rocket': '🚀', 'saturn': '🪐', 'star': '⭐', 'comet': '☄️',
    'astronaut': '👨‍🚀', 'ufo': '🛸', 'jupiter': '🪐', 'venus': '🪐', 'neptune': '🔵',
    'galaxy': '🌌', 'asteroid': '☄️', 'football': '⚽', 'basketball': '🏀',
    'tennis': '🎾', 'swimming': '🏊', 'cricket': '🏏', 'golf': '⛳', 'skiing': '⛷️',
    'hammer': '🔨', 'wrench': '🔧', 'screwdriver': '🪛', 'saw': '🪚', 'drill': '🔩',
    'pliers': '🔧', 'red': '🔴', 'blue': '🔵', 'green': '🟢', 'yellow': '🟡',
    'orange': '🟠', 'purple': '🟣', 'pink': '🩷',
  };
  return map[id] ?? '🖼️';
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

void _generateWhatAmI() {
  final riddles = [
    {'clues': ['I am yellow.', 'I grow on a tree.', 'Monkeys love me.'], 'answer': 'banana', 'choices': ['banana', 'lemon', 'apple', 'mango']},
    {'clues': ['I am king of the jungle.', 'I have a mane.', 'I roar loudly.'], 'answer': 'lion', 'choices': ['lion', 'cat', 'bear', 'tiger']},
    {'clues': ['I am big and grey.', 'I have a trunk.', 'I never forget.'], 'answer': 'elephant', 'choices': ['elephant', 'mouse', 'horse', 'rhino']},
    {'clues': ['I shine at night.', 'I am round.', 'Astronauts visited me.'], 'answer': 'moon', 'choices': ['moon', 'sun', 'star', 'cloud']},
    {'clues': ['I am red.', 'You eat me on pizza.', 'I am a fruit.'], 'answer': 'tomato', 'choices': ['tomato', 'apple', 'carrot', 'pepper']},
    {'clues': ['I am tall and metal.', 'I am in Paris, France.', 'I look like a tower.'], 'answer': 'eiffel', 'choices': ['eiffel', 'pyramid', 'castle', 'bridge']},
    {'clues': ['I am a country in Asia.', 'People eat sushi here.', 'Tokyo is my capital.'], 'answer': 'japan', 'choices': ['japan', 'mexico', 'france', 'brazil']},
    {'clues': ['I am hot and sandy.', 'Camels walk on me.', 'The Sahara is one of me.'], 'answer': 'desert', 'choices': ['desert', 'ocean', 'forest', 'snow']},
    {'clues': ['I am a long river.', 'I flow through Egypt.', 'Pyramids are near me.'], 'answer': 'nile', 'choices': ['nile', 'amazon', 'mississippi', 'thames']},
    {'clues': ['I am round and flat.', 'Italians love me.', 'I have cheese and tomato.'], 'answer': 'pizza', 'choices': ['pizza', 'taco', 'sushi', 'burger']},
    {'clues': ['I hop and have a pouch.', 'I live in Australia.', 'I am a kangaroo!'], 'answer': 'kangaroo', 'choices': ['kangaroo', 'penguin', 'panda', 'zebra']},
    {'clues': ['I am black and white.', 'I eat bamboo.', 'I live in China.'], 'answer': 'panda', 'choices': ['panda', 'zebra', 'penguin', 'koala']},
    {'clues': ['I have stripes.', 'I look like a horse.', 'I live in Africa.'], 'answer': 'zebra', 'choices': ['zebra', 'tiger', 'cow', 'deer']},
    {'clues': ['I am cold and white.', 'I fall from clouds.', 'You can build me.'], 'answer': 'snow', 'choices': ['snow', 'rain', 'sand', 'leaf']},
    {'clues': ['I am a famous wall.', 'I am very long.', 'I am in China.'], 'answer': 'greatwall', 'choices': ['greatwall', 'bridge', 'tower', 'castle']},
    {'clues': ['I am spicy food.', 'I come from India.', 'People eat me with rice.'], 'answer': 'curry', 'choices': ['curry', 'pizza', 'taco', 'pasta']},
    {'clues': ['I am a white monument.', 'I am in India.', 'It is a symbol of love.'], 'answer': 'tajmahal', 'choices': ['tajmahal', 'pyramid', 'castle', 'statue']},
    {'clues': ['I am a green fruit.', 'I am used in guacamole.', 'I grow on trees.'], 'answer': 'avocado', 'choices': ['avocado', 'grape', 'peach', 'melon']},
    {'clues': ['I am a triangle snack.', 'I come from Mexico.', 'I have a crunchy shell.'], 'answer': 'taco', 'choices': ['taco', 'pizza', 'donut', 'bread']},
    {'clues': ['I am the biggest ocean.', 'Whales swim in me.', 'I am very salty.'], 'answer': 'pacific', 'choices': ['pacific', 'desert', 'lake', 'river']},
    {'clues': ['I am a famous tower.', 'I lean to one side.', 'I am in Italy.'], 'answer': 'leaningtower', 'choices': ['leaningtower', 'eiffel', 'bridge', 'pyramid']},
    {'clues': ['I am a striped cat.', 'I live in the jungle.', 'I am orange and black.'], 'answer': 'tiger', 'choices': ['tiger', 'lion', 'cat', 'cheetah']},
    {'clues': ['I am a green animal.', 'I say ribbit.', 'I live near ponds.'], 'answer': 'frog', 'choices': ['frog', 'fish', 'duck', 'turtle']},
    {'clues': ['I am a yellow transport.', 'Kids ride me to school.', 'I am big and long.'], 'answer': 'bus', 'choices': ['bus', 'car', 'boat', 'plane']},
    {'clues': ['I fly in the sky.', 'I have wings.', 'Pilots fly me.'], 'answer': 'airplane', 'choices': ['airplane', 'car', 'train', 'boat']},
    {'clues': ['I am a cold place.', 'Polar bears live here.', 'It is at the top of Earth.'], 'answer': 'arctic', 'choices': ['arctic', 'desert', 'jungle', 'beach']},
    {'clues': ['I am a South American country.', 'I am famous for football.', 'Carnival is celebrated here.'], 'answer': 'brazil', 'choices': ['brazil', 'japan', 'egypt', 'canada']},
    {'clues': ['I am a breakfast food.', 'Chickens lay me.', 'You can fry or boil me.'], 'answer': 'egg', 'choices': ['egg', 'bread', 'rice', 'cheese']},
    {'clues': ['I am a tall plant.', 'I give shade.', 'Squirrels climb me.'], 'answer': 'tree', 'choices': ['tree', 'flower', 'grass', 'bush']},
    {'clues': ['I am worn on feet.', 'You tie my laces.', 'I help you run.'], 'answer': 'shoe', 'choices': ['shoe', 'hat', 'glove', 'sock']},
  ];
  const emojiMap = {
    'banana': '🍌', 'lemon': '🍋', 'apple': '🍎', 'mango': '🥭', 'lion': '🦁',
    'cat': '🐱', 'bear': '🐻', 'tiger': '🐯', 'elephant': '🐘', 'mouse': '🐭',
    'horse': '🐴', 'rhino': '🦏', 'moon': '🌙', 'sun': '☀️', 'star': '⭐',
    'cloud': '☁️', 'tomato': '🍅', 'carrot': '🥕', 'pepper': '🫑',
    'eiffel': '🗼', 'pyramid': '🔺', 'castle': '🏰', 'bridge': '🌉',
    'japan': '🇯🇵', 'mexico': '🇲🇽', 'france': '🇫🇷', 'brazil': '🇧🇷',
    'desert': '🏜️', 'ocean': '🌊', 'forest': '🌲', 'snow': '❄️',
    'nile': '🏞️', 'amazon': '🌿', 'mississippi': '🛶', 'thames': '🌉',
    'pizza': '🍕', 'taco': '🌮', 'sushi': '🍣', 'burger': '🍔',
    'kangaroo': '🦘', 'penguin': '🐧', 'panda': '🐼', 'zebra': '🦓',
    'greatwall': '🧱', 'tower': '🗼', 'curry': '🍛', 'pasta': '🍝',
    'tajmahal': '🕌', 'avocado': '🥑', 'grape': '🍇', 'peach': '🍑',
    'melon': '🍈', 'donut': '🍩', 'bread': '🍞', 'pacific': '🌊',
    'leaningtower': '🏛️', 'frog': '🐸', 'fish': '🐟', 'duck': '🦆',
    'turtle': '🐢', 'bus': '🚌', 'car': '🚗', 'boat': '⛵', 'plane': '✈️',
    'airplane': '✈️', 'train': '🚂', 'arctic': '🧊', 'egypt': '🇪🇬',
    'canada': '🇨🇦', 'egg': '🥚', 'rice': '🍚', 'cheese': '🧀',
    'tree': '🌳', 'flower': '🌸', 'grass': '🌿', 'bush': '🌿',
    'shoe': '👟', 'hat': '🎩', 'glove': '🧤', 'sock': '🧦',
  };

  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < riddles.length; i++) {
    final r = riddles[i];
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

void _generateSimonSays(int count) {
  const pads = [
    {'id': '0', 'emoji': '🥁', 'label': 'Drum', 'color': '#E53935'},
    {'id': '1', 'emoji': '🎹', 'label': 'Piano', 'color': '#1E88E5'},
    {'id': '2', 'emoji': '🎸', 'label': 'Guitar', 'color': '#43A047'},
    {'id': '3', 'emoji': '🎺', 'label': 'Trumpet', 'color': '#FFB300'},
  ];
  final levels = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    final length = (2 + (i ~/ 8)).clamp(2, 6);
    final sequence = List.generate(length, (_) => _rng.nextInt(4));
    levels.add({
      'id': 'simon_${(i + 1).toString().padLeft(3, '0')}',
      'gameType': 'simon_says',
      'zoneId': 'music_meadow',
      'levelNumber': i + 1,
      'difficulty': (i / 10).ceil().clamp(1, 5),
      'starsAvailable': 3,
      'scaffoldHints': 1,
      'learningMethod': ['memory', 'music'],
      'lumiLineKey': 'Watch the pattern, then copy it!',
      'sequenceItems': pads,
      'sequence': sequence,
      'relatedConcepts': ['music_meadow.simon'],
    });
  }
  final dir = Directory('assets/content/games/simon_says');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  _writeJson('assets/content/games/simon_says/levels.json', {'levels': levels});
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
    'counting': {'mechanic': 'count_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/math/counting.json']},
    'letter_recognition': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/alphabet/letter_recognition.json']},
    'letter_phonics': {'mechanic': 'phonics_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/alphabet/letter_phonics.json']},
    'dino_names': {'mechanic': 'tap_match', 'minLevels': 8, 'contentPaths': ['assets/content/learning/animals/dino_names.json']},
    'space_objects': {'mechanic': 'tap_match', 'minLevels': 15, 'contentPaths': ['assets/content/learning/animals/space_objects.json']},
    'sports_names': {'mechanic': 'tap_match', 'minLevels': 8, 'contentPaths': ['assets/content/learning/animals/sports_names.json']},
    'four_seasons': {'mechanic': 'tap_match', 'minLevels': 8, 'contentPaths': ['assets/content/learning/animals/four_seasons.json']},
    'household_items': {'mechanic': 'tap_match', 'minLevels': 8, 'contentPaths': ['assets/content/learning/animals/household_items.json']},
    'fun_colors': {'mechanic': 'tap_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/colors/fun_colors.json']},
    'color_recognition': {'mechanic': 'name_match', 'minLevels': 100, 'contentPaths': ['assets/content/learning/colors/color_recognition.json']},
    'opposites': {'mechanic': 'opposite_match', 'minLevels': 40, 'contentPaths': ['assets/content/learning/colors/opposites.json']},
    'shadow_game': {'mechanic': 'drag_drop', 'minLevels': 100, 'contentPaths': ['assets/content/games/shadow_game/levels.json']},
    'what_am_i': {'mechanic': 'riddle', 'minLevels': 30, 'contentPaths': ['assets/content/games/what_am_i/riddles.json']},
    'build_scene': {'mechanic': 'sandbox', 'minLevels': 18, 'contentPaths': ['assets/content/games/build_scene/scenes.json']},
    'which_tool_works': {'mechanic': 'select_piece', 'minLevels': 25, 'contentPaths': ['assets/content/games/tools/which_tool_works.json']},
    'true_false_animals': {'mechanic': 'true_false', 'minLevels': 8, 'contentPaths': ['assets/content/learning/true_false/true_false_animals.json']},
    'true_false_dino': {'mechanic': 'true_false', 'minLevels': 5, 'contentPaths': ['assets/content/learning/true_false/true_false_dino.json']},
    'true_false_space': {'mechanic': 'true_false', 'minLevels': 20, 'contentPaths': ['assets/content/learning/true_false/true_false_space.json']},
    'true_false_world': {'mechanic': 'true_false', 'minLevels': 25, 'contentPaths': ['assets/content/learning/true_false/true_false_world.json']},
    'simon_says': {'mechanic': 'simon', 'minLevels': 50, 'contentPaths': ['assets/content/games/simon_says/levels.json']},
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
  const open = {'unlockStars': 0, 'isFree': true, 'isSecret': false};
  return [
    {'id': 'jungle_grove', 'nameKey': 'zone.jungle_grove', 'levelCount': 600, 'gameTypes': ['animal_names', 'animal_world'], 'palette': {'primary': '#4CAF50', 'accent': '#FF9800'}, ...open, 'positionX': 0.2, 'positionY': 0.7},
    {'id': 'number_mountain', 'nameKey': 'zone.number_mountain', 'levelCount': 600, 'gameTypes': ['number_recognition', 'counting'], 'palette': {'primary': '#5C6BC0', 'accent': '#FF7043'}, ...open, 'positionX': 0.5, 'positionY': 0.15},
    {'id': 'letter_lane', 'nameKey': 'zone.letter_lane', 'levelCount': 600, 'gameTypes': ['letter_recognition', 'letter_phonics'], 'palette': {'primary': '#AB47BC', 'accent': '#26C6DA'}, ...open, 'positionX': 0.8, 'positionY': 0.15},
    {'id': 'color_canyon', 'nameKey': 'zone.color_canyon', 'levelCount': 600, 'gameTypes': ['color_recognition', 'fun_colors'], 'palette': {'primary': '#EC407A', 'accent': '#FFCA28'}, ...open, 'positionX': 0.5, 'positionY': 0.55},
    {'id': 'puzzle_palace', 'nameKey': 'zone.puzzle_palace', 'levelCount': 500, 'gameTypes': ['complete_picture', 'shadow_game'], 'palette': {'primary': '#7E57C2', 'accent': '#26A69A'}, ...open, 'positionX': 0.85, 'positionY': 0.55},
    {'id': 'world_village', 'nameKey': 'zone.world_village', 'levelCount': 73, 'gameTypes': ['what_am_i', 'build_scene', 'true_false_world'], 'palette': {'primary': '#00897B', 'accent': '#FFB300'}, ...open, 'positionX': 0.75, 'positionY': 0.75},
    {'id': 'music_meadow', 'nameKey': 'zone.music_meadow', 'levelCount': 50, 'gameTypes': ['simon_says'], 'palette': {'primary': '#D81B60', 'accent': '#8E24AA'}, ...open, 'positionX': 0.15, 'positionY': 0.15},
    {'id': 'opposites_ocean', 'nameKey': 'zone.opposites_ocean', 'levelCount': 40, 'gameTypes': ['opposites'], 'palette': {'primary': '#039BE5', 'accent': '#00ACC1'}, ...open, 'positionX': 0.65, 'positionY': 0.4},
    {'id': 'dinosaurs', 'nameKey': 'zone.dinosaurs', 'levelCount': 13, 'gameTypes': ['dino_names', 'true_false_dino'], 'palette': {'primary': '#795548', 'accent': '#FF8F00'}, ...open, 'positionX': 0.85, 'positionY': 0.25},
    {'id': 'space_science', 'nameKey': 'zone.space_science', 'levelCount': 35, 'gameTypes': ['space_objects', 'true_false_space'], 'palette': {'primary': '#283593', 'accent': '#7E57C2'}, ...open, 'positionX': 0.95, 'positionY': 0.1},
    {'id': 'tools_professions', 'nameKey': 'zone.tools_professions', 'levelCount': 25, 'gameTypes': ['which_tool_works'], 'palette': {'primary': '#546E7A', 'accent': '#FF7043'}, ...open, 'positionX': 0.35, 'positionY': 0.85},
    {'id': 'sports_body', 'nameKey': 'zone.sports_body', 'levelCount': 8, 'gameTypes': ['sports_names'], 'palette': {'primary': '#E53935', 'accent': '#1E88E5'}, ...open, 'positionX': 0.9, 'positionY': 0.85},
    {'id': 'seasons_holidays', 'nameKey': 'zone.seasons_holidays', 'levelCount': 8, 'gameTypes': ['four_seasons'], 'palette': {'primary': '#43A047', 'accent': '#FB8C00'}, ...open, 'positionX': 0.55, 'positionY': 0.85},
    {'id': 'household_daily', 'nameKey': 'zone.household_daily', 'levelCount': 8, 'gameTypes': ['household_items'], 'palette': {'primary': '#6D4C41', 'accent': '#FFA726'}, ...open, 'positionX': 0.7, 'positionY': 0.65},
    {'id': 'drawing_den', 'nameKey': 'zone.drawing_den', 'levelCount': 250, 'gameTypes': ['coloring', 'free_draw'], 'palette': {'primary': '#42A5F5', 'accent': '#FF7043'}, ...open, 'positionX': 0.1, 'positionY': 0.5},
  ];
}
