/// Maps game item IDs to local PNG assets (Kenney CC0 + generated tiles).
class GameImageResolver {
  GameImageResolver._();

  static const _animalIds = {
    'lion', 'elephant', 'giraffe', 'monkey', 'cow', 'sheep', 'pig',
    'chicken', 'horse', 'duck', 'frog', 'bear', 'penguin', 'shark', 'butterfly',
  };

  static const _dinoIds = {
    'trex', 'triceratops', 'stego', 'brachio', 'veloci', 'ptero', 'ankylo', 'spino',
  };

  static const _spaceIds = {
    'sun', 'moon', 'earth', 'mars', 'rocket', 'saturn', 'star', 'comet',
  };

  static const _sportIds = {
    'football', 'basketball', 'tennis', 'swimming', 'cricket', 'golf', 'skiing',
  };

  static const _toolIds = {
    'hammer', 'wrench', 'screwdriver', 'saw', 'drill', 'pliers',
  };

  static const _colorIds = {
    'red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'black', 'white',
  };

  /// Returns asset path if a PNG exists for this id, else null (use emoji).
  static String? assetForId(String id) {
    final key = id.toLowerCase();

    if (key.startsWith('letter_')) {
      final letter = key.replaceAll('letter_', '').toUpperCase();
      return 'assets/images/game/letters/letter_$letter.png';
    }
    if (key.startsWith('num_')) {
      return 'assets/images/game/numbers/$key.png';
    }
    if (_animalIds.contains(key)) {
      return 'assets/images/game/animals/$key.png';
    }
    if (_dinoIds.contains(key)) {
      final mapped = _dinoFileName(key);
      return 'assets/images/game/dinosaurs/$mapped.png';
    }
    if (_spaceIds.contains(key)) {
      return 'assets/images/game/space/$key.png';
    }
    if (_sportIds.contains(key)) {
      return 'assets/images/game/sports/$key.png';
    }
    if (_toolIds.contains(key)) {
      return 'assets/images/game/tools/$key.png';
    }
    if (_colorIds.contains(key)) {
      return 'assets/images/game/colors/$key.png';
    }
    return null;
  }

  /// Resolves option `image` paths like assets/images/games/sheep.png to Twemoji PNGs.
  static String? assetFromImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    final base = imagePath.split('/').last.replaceAll('.png', '').replaceAll('_full', '');
    return assetForId(base);
  }

  /// Theme animal/object from reference image or related concept string.
  static String? themeFromLevel({
    String? referenceImage,
    List<String> relatedConcepts = const [],
  }) {
    if (referenceImage != null) {
      final base = referenceImage.split('/').last.replaceAll('.png', '').replaceAll('_full', '');
      final resolved = assetForId(base);
      if (resolved != null) return resolved;
    }
    for (final c in relatedConcepts) {
      final parts = c.split('.');
      if (parts.isNotEmpty) {
        final id = parts.last;
        final resolved = assetForId(id);
        if (resolved != null) return resolved;
      }
    }
    return null;
  }

  static String _dinoFileName(String id) {
    const map = {
      'trex': 'trex',
      'triceratops': 'triceratops',
      'stego': 'stego',
      'brachio': 'brachio',
      'veloci': 'trex',
      'ptero': 'ptero',
      'ankylo': 'triceratops',
      'spino': 'trex',
    };
    return map[id] ?? id;
  }

  static Map<String, dynamic> enrichChoice(Map<String, dynamic> choice) {
    final id = choice['id']?.toString() ?? '';
    final imagePath = assetForId(id);
    if (imagePath != null) {
      return {...choice, 'imagePath': imagePath};
    }
    return choice;
  }

  static List<Map<String, dynamic>> enrichChoices(
    List<Map<String, dynamic>> choices,
  ) =>
      choices.map(enrichChoice).toList();
}
