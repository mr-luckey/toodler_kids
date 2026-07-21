class AppConstants {
  AppConstants._();

  static const String appName = 'KidsLearnPlay';
  static const String appTagline = 'Learn, Play, Grow — Every tap is a discovery.';
  static const String manifestPath = 'assets/content/manifest.json';
  static const String localizationEnPath = 'assets/content/localization/en.json';
  static const String localizationUrPath = 'assets/content/localization/ur.json';

  static const double minTouchTargetTiny = 72.0;
  static const double minTouchTargetLittle = 56.0;
  static const double minTouchTargetJunior = 48.0;

  static const int maxUndoSteps = 20;
  static const int funFactChancePercent = 33;
  static const int sessionsForLearningMap = 5;
}

enum AgeTier {
  tinyExplorers('tiny_explorers', 1.5, 3, 2),
  littleLearners('little_learners', 3, 5, 4),
  juniorScholars('junior_scholars', 5, 7, 8);

  const AgeTier(this.id, this.minAge, this.maxAge, this.maxScreenItems);
  final String id;
  final double minAge;
  final double maxAge;
  final int maxScreenItems;
}

enum LumiEmotion {
  happy,
  sad,
  excited,
  proud,
  thinking,
  surprised,
  encouraging,
  sleepy,
}

enum GameMechanic {
  tapReveal('tap_reveal'),
  tapMatch('tap_match'),
  dragDrop('drag_drop'),
  trace('trace'),
  trueFalse('true_false'),
  sequence('sequence'),
  sandbox('sandbox'),
  colorFill('color_fill'),
  simon('simon'),
  selectPiece('select_piece'),
  riddle('riddle');

  const GameMechanic(this.id);
  final String id;
}
