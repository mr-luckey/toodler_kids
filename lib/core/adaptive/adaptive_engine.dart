import 'dart:math';

import 'package:toodler_kids/data/datasources/local_progress_datasource.dart';

class ConceptRecord {
  ConceptRecord({
    required this.concept,
    required this.masteryScore,
    required this.lastReviewed,
    required this.nextReview,
    required this.attempts,
    required this.successes,
  });

  final String concept;
  double masteryScore;
  DateTime lastReviewed;
  DateTime nextReview;
  int attempts;
  int successes;

  Map<String, dynamic> toJson() => {
        'concept': concept,
        'masteryScore': masteryScore,
        'lastReviewed': lastReviewed.toIso8601String(),
        'nextReview': nextReview.toIso8601String(),
        'attempts': attempts,
        'successes': successes,
      };

  factory ConceptRecord.fromJson(Map<String, dynamic> json) => ConceptRecord(
        concept: json['concept'] as String,
        masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
        lastReviewed: DateTime.parse(json['lastReviewed'] as String),
        nextReview: DateTime.parse(json['nextReview'] as String),
        attempts: json['attempts'] as int? ?? 0,
        successes: json['successes'] as int? ?? 0,
      );
}

class LearningMapEntry {
  const LearningMapEntry({
    required this.concept,
    required this.score,
    required this.isStrength,
  });

  final String concept;
  final double score;
  final bool isStrength;
}

class AdaptiveEngine {
  AdaptiveEngine({LocalProgressDataSource? dataSource})
      : _dataSource = dataSource;

  LocalProgressDataSource? _dataSource;
  final Map<String, ConceptRecord> _concepts = {};

  void attachDataSource(LocalProgressDataSource dataSource) {
    _dataSource = dataSource;
  }

  Future<void> init() async {
    if (_dataSource == null) return;
    final data = await _dataSource!.getAdaptiveData();
    for (final entry in data.entries) {
      _concepts[entry.key] =
          ConceptRecord.fromJson(Map<String, dynamic>.from(entry.value as Map));
    }
  }

  Future<void> recordAttempt({
    required String concept,
    required bool success,
    required int stars,
  }) async {
    final now = DateTime.now();
    final existing = _concepts[concept];

    if (existing == null) {
      _concepts[concept] = ConceptRecord(
        concept: concept,
        masteryScore: success ? 0.3 : 0.1,
        lastReviewed: now,
        nextReview: now.add(Duration(days: success ? 2 : 1)),
        attempts: 1,
        successes: success ? 1 : 0,
      );
    } else {
      existing.attempts++;
      if (success) existing.successes++;
      final rate = existing.successes / existing.attempts;
      existing.masteryScore = (existing.masteryScore * 0.7) + (rate * 0.3);
      existing.lastReviewed = now;

      if (existing.masteryScore < 0.5) {
        existing.nextReview = now.add(const Duration(days: 1));
      } else if (existing.masteryScore < 0.8) {
        existing.nextReview = now.add(const Duration(days: 4));
      } else {
        existing.nextReview = now.add(const Duration(days: 8));
      }
    }

    await _persist();
  }

  List<String> getConceptsDueForReview() {
    final now = DateTime.now();
    return _concepts.entries
        .where((e) => e.value.nextReview.isBefore(now))
        .map((e) => e.key)
        .toList();
  }

  List<LearningMapEntry> getLearningMap() {
    return _concepts.entries.map((e) {
      return LearningMapEntry(
        concept: e.key,
        score: e.value.masteryScore,
        isStrength: e.value.masteryScore >= 0.75,
      );
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  List<String> getRecommendedConcepts({int count = 3}) {
    final due = getConceptsDueForReview();
    if (due.isNotEmpty) return due.take(count).toList();

    final weak = _concepts.entries
        .where((e) => e.value.masteryScore < 0.6)
        .map((e) => e.key)
        .toList();
    return weak.take(count).toList();
  }

  int getScaffoldHintsAvailable(int baseHints, String concept) {
    final record = _concepts[concept];
    if (record == null) return baseHints;
    if (record.masteryScore >= 0.8) return max(0, baseHints - 2);
    if (record.masteryScore >= 0.5) return max(1, baseHints - 1);
    return baseHints;
  }

  Future<void> _persist() async {
    if (_dataSource == null) return;
    final data = _concepts.map((k, v) => MapEntry(k, v.toJson()));
    await _dataSource!.saveAdaptiveData(data);
  }
}
