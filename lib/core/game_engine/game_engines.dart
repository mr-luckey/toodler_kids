import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/assets/game_image_resolver.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/presentation/widgets/cartoon_game_widgets.dart';
import 'package:toodler_kids/domain/entities/entities.dart';

/// Engine 1: Tap to Reveal
class TapRevealEngine extends StatelessWidget {
  const TapRevealEngine({
    super.key,
    required this.items,
    required this.onItemTapped,
  });

  final List<Map<String, dynamic>> items;
  final void Function(Map<String, dynamic> item) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: items.map((item) {
        return GestureDetector(
          onTap: () => onItemTapped(item),
          child: _ItemCard(
            emoji: item['emoji'] as String? ?? '❓',
            label: item['label'] as String? ?? '',
          ),
        );
      }).toList(),
    );
  }
}

/// Engine 2: Tap to Match
class TapMatchEngine extends StatefulWidget {
  const TapMatchEngine({
    super.key,
    required this.prompt,
    required this.choices,
    required this.onChoice,
    this.target,
    this.correctId,
    this.showHint = false,
    this.hintOptionId,
    this.accentColor,
  });

  final String prompt;
  final List<Map<String, dynamic>> choices;
  final void Function(String choiceId, bool isCorrect) onChoice;
  final Map<String, dynamic>? target;
  final String? correctId;
  final bool showHint;
  final String? hintOptionId;
  final Color? accentColor;

  @override
  State<TapMatchEngine> createState() => _TapMatchEngineState();
}

class _TapMatchEngineState extends State<TapMatchEngine> {
  String? _selectedId;
  int _bounceTrigger = 0;
  bool _locked = false;
  bool _showBurst = false;

  @override
  void didUpdateWidget(covariant TapMatchEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.choices != widget.choices ||
        oldWidget.prompt != widget.prompt) {
      _selectedId = null;
      _bounceTrigger = 0;
      _locked = false;
      _showBurst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF5C6BC0);
    final subtitleColor = _readableAccent(context, accent);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.7;
        final compact = h < 580;
        final veryCompact = h < 500;
        final choiceMin = veryCompact
            ? 52.0
            : compact
                ? 58.0
                : Responsive.touchTarget(context);
        final gap = veryCompact ? 6.0 : (compact ? 8.0 : 12.0);
        final heroCircle = veryCompact ? 64.0 : (compact ? 80.0 : 110.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartoonPromptBubble(
                      text: widget.prompt,
                      accent: accent,
                      compact: compact,
                    ),
                    if (widget.target != null) ...[
                      SizedBox(height: gap),
                      CartoonTargetHero(
                        label: widget.target!['label'] as String? ?? '',
                        emoji: widget.target!['emoji'] as String?,
                        imagePath: widget.target!['imagePath'] as String?,
                        accent: accent,
                        compact: compact,
                        circleSize: heroCircle,
                      ),
                      if (!veryCompact) ...[
                        SizedBox(height: gap * 0.6),
                        Text(
                          'Tap the matching one below!',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: subtitleColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: compact ? 13 : null,
                                  ),
                        ),
                      ],
                    ] else ...[
                      SizedBox(height: gap * 0.5),
                      Text(
                        'Tap the matching one below!',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: subtitleColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                    SizedBox(height: gap),
                    Wrap(
                      spacing: compact ? 8 : 12,
                      runSpacing: compact ? 10 : 14,
                      alignment: WrapAlignment.center,
                      children: widget.choices.map((c) {
                        final id = c['id'] as String;
                        final isCorrect =
                            c['isCorrect'] as bool? ?? id == widget.correctId;
                        final showGlow = widget.showHint &&
                            (widget.hintOptionId == id ||
                                (isCorrect && widget.hintOptionId == null));
                        return BounceBackAnimation(
                          trigger: _selectedId == id && !isCorrect
                              ? _bounceTrigger
                              : 0,
                          child: ScaffoldHintGlow(
                            showGlow: showGlow,
                            child: CartoonChoiceCard(
                              emoji: c['emoji'] as String? ?? '❓',
                              imagePath: c['imagePath'] as String?,
                              label: c['label'] as String? ?? '',
                              minSize: choiceMin,
                              compact: compact,
                              borderColor: accent,
                              selected: _selectedId == id && isCorrect,
                              onTap: _locked
                                  ? null
                                  : () => _onTap(id, isCorrect),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            CorrectAnswerBurst(visible: _showBurst),
          ],
        );
      },
    );
  }

  void _onTap(String id, bool isCorrect) {
    setState(() => _selectedId = id);
    if (!isCorrect) {
      setState(() => _bounceTrigger++);
      widget.onChoice(id, false);
      return;
    }
    setState(() {
      _locked = true;
      _showBurst = true;
    });
    getIt<SoundManager>().playCorrectChime();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) widget.onChoice(id, true);
    });
  }
}

/// Engine 2b: Name Match — see picture, pick the written name.
class NameMatchEngine extends StatefulWidget {
  const NameMatchEngine({
    super.key,
    required this.prompt,
    required this.target,
    required this.choices,
    required this.onChoice,
    this.showHint = false,
    this.hintOptionId,
    this.accentColor,
    this.heroHeader,
  });

  final String prompt;
  final Map<String, dynamic> target;
  final List<Map<String, dynamic>> choices;
  final void Function(String choiceId, bool isCorrect) onChoice;
  final bool showHint;
  final String? hintOptionId;
  final Color? accentColor;
  final String? heroHeader;

  @override
  State<NameMatchEngine> createState() => _NameMatchEngineState();
}

class _NameMatchEngineState extends State<NameMatchEngine> {
  String? _selectedId;
  int _bounceTrigger = 0;
  bool _locked = false;
  bool _showBurst = false;

  @override
  void didUpdateWidget(covariant NameMatchEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.choices != widget.choices ||
        oldWidget.prompt != widget.prompt) {
      _selectedId = null;
      _bounceTrigger = 0;
      _locked = false;
      _showBurst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF4CAF50);
    final subtitleColor = _readableAccent(context, accent);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.7;
        final compact = h < 580;
        final veryCompact = h < 500;
        final choiceMin = veryCompact
            ? 52.0
            : compact
                ? 58.0
                : Responsive.touchTarget(context);
        final gap = veryCompact ? 6.0 : (compact ? 8.0 : 12.0);
        final heroCircle = veryCompact ? 64.0 : (compact ? 80.0 : 110.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartoonPromptBubble(
                      text: widget.prompt,
                      accent: accent,
                      compact: compact,
                    ),
                    SizedBox(height: gap),
                    CartoonTargetHero(
                      label: '',
                      emoji: widget.target['emoji'] as String?,
                      imagePath: widget.target['imagePath'] as String?,
                      accent: accent,
                      hideLabel: true,
                      header: widget.heroHeader,
                      displayLabel: widget.target['label'] as String?,
                      compact: compact,
                      circleSize: heroCircle,
                    ),
                    if (!veryCompact) ...[
                      SizedBox(height: gap * 0.6),
                      Text(
                        'Pick the right name!',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: subtitleColor,
                              fontWeight: FontWeight.w700,
                              fontSize: compact ? 13 : null,
                            ),
                      ),
                    ],
                    SizedBox(height: gap),
                    Wrap(
                      spacing: compact ? 8 : 12,
                      runSpacing: compact ? 10 : 14,
                      alignment: WrapAlignment.center,
                      children: widget.choices.map((c) {
                        final id = c['id'] as String;
                        final isCorrect = c['isCorrect'] as bool? ?? false;
                        final showGlow =
                            widget.showHint && widget.hintOptionId == id;
                        return BounceBackAnimation(
                          trigger: _selectedId == id && !isCorrect
                              ? _bounceTrigger
                              : 0,
                          child: ScaffoldHintGlow(
                            showGlow: showGlow,
                            child: CartoonChoiceCard(
                              label: c['label'] as String? ?? id,
                              minSize: choiceMin,
                              compact: compact,
                              borderColor: accent,
                              textOnly: true,
                              selected: _selectedId == id && isCorrect,
                              onTap: _locked
                                  ? null
                                  : () => _onTap(id, isCorrect),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            CorrectAnswerBurst(visible: _showBurst),
          ],
        );
      },
    );
  }

  void _onTap(String id, bool isCorrect) {
    setState(() => _selectedId = id);
    if (!isCorrect) {
      setState(() => _bounceTrigger++);
      widget.onChoice(id, false);
      return;
    }
    setState(() {
      _locked = true;
      _showBurst = true;
    });
    getIt<SoundManager>().playCorrectChime();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) widget.onChoice(id, true);
    });
  }
}

/// Engine 2c: Count Match — count objects, pick the number.
class CountMatchEngine extends StatefulWidget {
  const CountMatchEngine({
    super.key,
    required this.prompt,
    required this.count,
    required this.countEmoji,
    required this.choices,
    required this.onChoice,
    this.showHint = false,
    this.hintOptionId,
    this.accentColor,
  });

  final String prompt;
  final int count;
  final String countEmoji;
  final List<Map<String, dynamic>> choices;
  final void Function(String choiceId, bool isCorrect) onChoice;
  final bool showHint;
  final String? hintOptionId;
  final Color? accentColor;

  @override
  State<CountMatchEngine> createState() => _CountMatchEngineState();
}

class _CountMatchEngineState extends State<CountMatchEngine> {
  String? _selectedId;
  int _bounceTrigger = 0;
  bool _locked = false;
  bool _showBurst = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF5C6BC0);
    final subtitleColor = _readableAccent(context, accent);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.7;
        final compact = h < 580;
        final veryCompact = h < 500;
        final choiceMin = veryCompact
            ? 52.0
            : compact
                ? 58.0
                : Responsive.touchTarget(context);
        final gap = veryCompact ? 6.0 : (compact ? 8.0 : 12.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartoonPromptBubble(
                      text: widget.prompt,
                      accent: accent,
                      compact: compact,
                    ),
                    SizedBox(height: gap),
                    CartoonCountHero(
                      count: widget.count,
                      emoji: widget.countEmoji,
                      accent: accent,
                    ),
                    if (!veryCompact) ...[
                      SizedBox(height: gap * 0.6),
                      Text(
                        'Pick the right number!',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: compact ? 13 : null,
                                ),
                      ),
                    ],
                    SizedBox(height: gap),
                    Wrap(
                      spacing: compact ? 8 : 12,
                      runSpacing: compact ? 10 : 14,
                      alignment: WrapAlignment.center,
                      children: widget.choices.map((c) {
                        final id = c['id'] as String;
                        final isCorrect = c['isCorrect'] as bool? ?? false;
                        final showGlow =
                            widget.showHint && widget.hintOptionId == id;
                        return BounceBackAnimation(
                          trigger: _selectedId == id && !isCorrect
                              ? _bounceTrigger
                              : 0,
                          child: ScaffoldHintGlow(
                            showGlow: showGlow,
                            child: CartoonChoiceCard(
                              label: c['label'] as String? ?? id,
                              minSize: choiceMin,
                              compact: compact,
                              borderColor: accent,
                              textOnly: true,
                              selected: _selectedId == id && isCorrect,
                              onTap: _locked
                                  ? null
                                  : () => _onTap(id, isCorrect),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            CorrectAnswerBurst(visible: _showBurst),
          ],
        );
      },
    );
  }

  void _onTap(String id, bool isCorrect) {
    setState(() => _selectedId = id);
    if (!isCorrect) {
      setState(() => _bounceTrigger++);
      widget.onChoice(id, false);
      return;
    }
    setState(() {
      _locked = true;
      _showBurst = true;
    });
    getIt<SoundManager>().playCorrectChime();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) widget.onChoice(id, true);
    });
  }
}

/// Engine 3: Drag & Drop (Shadow Game uses silhouette targets)
class DragDropEngine extends StatelessWidget {
  const DragDropEngine({
    super.key,
    required this.draggableItem,
    required this.targets,
    required this.onDropped,
    this.subjectImagePath,
    this.prompt = 'Match the shadow!',
    this.accentColor,
  });

  final Map<String, dynamic> draggableItem;
  final List<Map<String, dynamic>> targets;
  final void Function(String targetId, bool isCorrect) onDropped;
  final String? subjectImagePath;
  final String prompt;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFF7E57C2);
    final emoji = draggableItem['emoji'] as String? ?? '📦';
    final label = draggableItem['label'] as String? ?? '';
    final imagePath = subjectImagePath ??
        draggableItem['imagePath'] as String? ??
        GameImageResolver.assetForId(label.toLowerCase());

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 520;
        final card = (math.min(constraints.maxWidth * 0.28, 110.0))
            .clamp(72.0, 110.0)
            .toDouble();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          child: Column(
            children: [
              CartoonPromptBubble(
                text: prompt,
                accent: accent,
                compact: compact,
              ),
              const SizedBox(height: 8),
              Text(
                'Drag me onto my shadow!',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
              const SizedBox(height: 10),
              Draggable<String>(
                data: draggableItem['id'] as String,
                feedback: Material(
                  color: Colors.transparent,
                  child: _ShadowSubjectCard(
                    size: card,
                    emoji: emoji,
                    label: label,
                    imagePath: imagePath,
                    accent: accent,
                    silhouette: false,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.25,
                  child: _ShadowSubjectCard(
                    size: card,
                    emoji: emoji,
                    label: label,
                    imagePath: imagePath,
                    accent: accent,
                    silhouette: false,
                  ),
                ),
                child: _ShadowSubjectCard(
                  size: card,
                  emoji: emoji,
                  label: label,
                  imagePath: imagePath,
                  accent: accent,
                  silhouette: false,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: targets.map((t) {
                  final isCorrectBin = t['acceptsId'] == draggableItem['id'];
                  final decoyId = t['decoyId'] as String?;
                  final binImage = isCorrectBin
                      ? imagePath
                      : (GameImageResolver.assetForId(decoyId ?? '') ??
                          imagePath);
                  final binEmoji = isCorrectBin
                      ? emoji
                      : (t['emoji'] as String? ?? '⬛');
                  return DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      onDropped(
                        t['id'] as String,
                        details.data == t['acceptsId'],
                      );
                    },
                    builder: (context, candidate, rejected) {
                      return _ShadowSubjectCard(
                        size: card,
                        emoji: binEmoji,
                        label: '',
                        imagePath: binImage,
                        accent: candidate.isNotEmpty
                            ? AppTheme.success
                            : accent,
                        silhouette: true,
                        highlighted: candidate.isNotEmpty,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShadowSubjectCard extends StatelessWidget {
  const _ShadowSubjectCard({
    required this.size,
    required this.emoji,
    required this.label,
    required this.accent,
    required this.silhouette,
    this.imagePath,
    this.highlighted = false,
  });

  final double size;
  final String emoji;
  final String label;
  final Color accent;
  final bool silhouette;
  final String? imagePath;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    Widget art;
    if (imagePath != null) {
      final image = Image.asset(
        imagePath!,
        fit: BoxFit.contain,
        width: size * 0.62,
        height: size * 0.62,
        errorBuilder: (context, error, stackTrace) => Text(
          emoji,
          style: TextStyle(fontSize: size * 0.4),
        ),
      );
      art = silhouette
          ? ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
              child: image,
            )
          : image;
    } else {
      art = Text(emoji, style: TextStyle(fontSize: size * 0.4));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: highlighted
                ? AppTheme.success.withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: highlighted ? AppTheme.success : accent,
              width: highlighted ? 4 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.28),
                offset: const Offset(0, 5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(child: art),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          SizedBox(
            width: size + 8,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3142),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Engine 5: True/False
class TrueFalseEngine extends StatelessWidget {
  const TrueFalseEngine({
    super.key,
    required this.statement,
    required this.onAnswer,
  });

  final String statement;
  final void Function(bool answer) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CartoonPromptBubble(text: statement),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 400;
              return Row(
                children: [
                  Expanded(
                    child: _AnswerButton(
                      label: '✅ True',
                      color: AppTheme.success,
                      onTap: () => onAnswer(true),
                    ),
                  ),
                  SizedBox(width: wide ? 16 : 12),
                  Expanded(
                    child: _AnswerButton(
                      label: '❌ False',
                      color: AppTheme.error,
                      onTap: () => onAnswer(false),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Engine 6: Sequence / Arrange in Order
class SequenceEngine extends StatefulWidget {
  const SequenceEngine({
    super.key,
    required this.items,
    required this.onComplete,
  });

  final List<Map<String, dynamic>> items;
  final void Function(bool correct) onComplete;

  @override
  State<SequenceEngine> createState() => _SequenceEngineState();
}

class _SequenceEngineState extends State<SequenceEngine> {
  late List<Map<String, dynamic>> _ordered;

  @override
  void initState() {
    super.initState();
    _ordered = List.from(widget.items)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Drag items into the right order',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _ordered.removeAt(oldIndex);
                _ordered.insert(newIndex, item);
              });
              _checkOrder();
            },
            children: _ordered.map((item) {
              return ListTile(
                key: ValueKey(item['id']),
                leading: Text(
                  item['emoji'] as String? ?? '🔢',
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(item['label'] as String? ?? ''),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _checkOrder() {
    var correct = true;
    for (var i = 0; i < _ordered.length; i++) {
      if (_ordered[i]['order'] != i + 1) correct = false;
    }
    if (correct) widget.onComplete(true);
  }
}

/// Engine 7: Sandbox (Build a Scene)
class SandboxEngine extends StatelessWidget {
  const SandboxEngine({
    super.key,
    required this.backgroundEmoji,
    required this.itemTray,
    required this.placedItems,
    required this.onItemPlaced,
  });

  final String backgroundEmoji;
  final List<Map<String, dynamic>> itemTray;
  final List<Map<String, dynamic>> placedItems;
  final void Function(Map<String, dynamic> item, Offset position) onItemPlaced;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  backgroundEmoji,
                  style: TextStyle(fontSize: Responsive.scale(context, 72, 96)),
                ),
              ),
              ...placedItems.map((item) {
                return Positioned(
                  left: (item['x'] as num?)?.toDouble() ?? 0,
                  top: (item['y'] as num?)?.toDouble() ?? 0,
                  child: Text(
                    item['emoji'] as String? ?? '⭐',
                    style: const TextStyle(fontSize: 36),
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: itemTray.length,
            separatorBuilder: (_, index) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final item = itemTray[index];
              return GestureDetector(
                onTap: () => onItemPlaced(
                  item,
                  Offset((placedItems.length * 40.0) + 20, 100),
                ),
                child: Container(
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    item['emoji'] as String? ?? '⭐',
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Engine 9: Simon Says — watch pattern, then repeat on music pads.
class SimonEngine extends StatefulWidget {
  const SimonEngine({
    super.key,
    required this.sequence,
    required this.pads,
    required this.onComplete,
    this.prompt = 'Watch the pattern!',
    this.onPadSound,
  });

  final List<int> sequence;
  final List<Map<String, dynamic>> pads;
  final void Function(bool success) onComplete;
  final String prompt;
  final void Function(int padIndex)? onPadSound;

  @override
  State<SimonEngine> createState() => _SimonEngineState();
}

class _SimonEngineState extends State<SimonEngine> {
  int _playerIndex = 0;
  int? _highlighted;
  bool _watchPhase = true;
  bool _inputEnabled = false;
  bool _showBurst = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSequence());
  }

  @override
  void didUpdateWidget(covariant SimonEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sequence != widget.sequence) {
      _playerIndex = 0;
      _watchPhase = true;
      _inputEnabled = false;
      _showBurst = false;
      _playSequence();
    }
  }

  Future<void> _playSequence() async {
    if (!mounted) return;
    setState(() {
      _watchPhase = true;
      _inputEnabled = false;
    });
    await Future<void>.delayed(const Duration(milliseconds: 600));
    for (var i = 0; i < widget.sequence.length; i++) {
      if (!mounted) return;
      setState(() => _highlighted = widget.sequence[i]);
      widget.onPadSound?.call(widget.sequence[i]);
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => _highlighted = null);
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    if (!mounted) return;
    setState(() {
      _watchPhase = false;
      _inputEnabled = true;
    });
  }

  Color _padColor(int index) {
    final hex = widget.pads[index]['color'] as String? ?? '#6C63FF';
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CartoonPromptBubble(
          text: _watchPhase ? widget.prompt : 'Your turn — copy it! 🎵',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth.clamp(220.0, 420.0);
            return Center(
              child: SizedBox(
                width: size,
                height: size,
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(widget.pads.length, (i) {
                    final pad = widget.pads[i];
                    final active = _highlighted == i;
                    final base = _padColor(i);
                    return GestureDetector(
                      onTap: _inputEnabled ? () => _onPadTap(i) : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: active ? base : base.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: active ? Colors.white : base.withValues(alpha: 0.8),
                            width: active ? 4 : 3,
                          ),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: base.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: base.withValues(alpha: 0.35),
                                    offset: const Offset(0, 5),
                                    blurRadius: 0,
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pad['emoji'] as String? ?? '🎵',
                              style: TextStyle(fontSize: size * 0.14),
                            ),
                            Text(
                              pad['label'] as String? ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ],
    ),
        CorrectAnswerBurst(visible: _showBurst),
      ],
    );
  }

  void _onPadTap(int index) {
    if (!_inputEnabled) return;
    widget.onPadSound?.call(index);
    if (widget.sequence[_playerIndex] == index) {
      setState(() {
        _playerIndex++;
        _highlighted = index;
      });
      Future.delayed(const Duration(milliseconds: 280), () {
        if (mounted) setState(() => _highlighted = null);
      });
      if (_playerIndex >= widget.sequence.length) {
        setState(() {
          _inputEnabled = false;
          _showBurst = true;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) widget.onComplete(true);
        });
      }
    } else {
      setState(() => _inputEnabled = false);
      widget.onComplete(false);
    }
  }
}

/// Engine 10: Select the Piece (Complete Picture, Which Tool Works)
class SelectPieceEngine extends StatefulWidget {
  const SelectPieceEngine({
    super.key,
    required this.level,
    required this.onPieceSelected,
    this.hintOptionId,
    this.accentColor,
    this.prompt = 'Find the missing piece! 🧩',
  });

  final GameLevelEntity level;
  final void Function(LevelOption option, bool isCorrect) onPieceSelected;
  final String? hintOptionId;
  final Color? accentColor;
  final String prompt;

  @override
  State<SelectPieceEngine> createState() => _SelectPieceEngineState();
}

class _SelectPieceEngineState extends State<SelectPieceEngine> {
  int _bounceTrigger = 0;
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF7E57C2);
    final themeImage = GameImageResolver.themeFromLevel(
      referenceImage: widget.level.referenceImage,
      relatedConcepts: widget.level.relatedConcepts,
    );
    final themeEmoji = _emojiForLevel(widget.level);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = (constraints.maxHeight * 0.48)
            .clamp(150.0, 240.0)
            .toDouble();
        final maxBoardW = (constraints.maxWidth - 32).clamp(150.0, 280.0);
        final size = boardSize < maxBoardW ? boardSize : maxBoardW;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: CartoonPromptBubble(
                text: widget.prompt,
                accent: accent,
              ),
            ),
            Expanded(
              child: Center(
                child: CartoonPuzzleBoard(
                  rows: widget.level.boardRows.clamp(1, 6),
                  cols: widget.level.boardCols.clamp(1, 6),
                  missingSlots: widget.level.missingSlots,
                  themeImagePath: themeImage,
                  themeEmoji: themeEmoji,
                  accent: accent,
                  size: size,
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.level.options.map((option) {
                      final showHint = widget.hintOptionId == option.id;
                      final imagePath = GameImageResolver.assetFromImagePath(
                            option.image,
                          ) ??
                          GameImageResolver.assetForId(option.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: BounceBackAnimation(
                          trigger: _selectedId == option.id && !option.isCorrect
                              ? _bounceTrigger
                              : 0,
                          child: ScaffoldHintGlow(
                            showGlow: showHint,
                            child: CartoonChoiceCard(
                              emoji: _emojiForOption(option),
                              imagePath: imagePath,
                              label: _labelForOption(option),
                              minSize: Responsive.touchTarget(context),
                              borderColor: accent,
                              selected:
                                  _selectedId == option.id && option.isCorrect,
                              onTap: () => _onSelect(option),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSelect(LevelOption option) {
    setState(() => _selectedId = option.id);
    if (!option.isCorrect) {
      setState(() => _bounceTrigger++);
    } else {
      getIt<SoundManager>().playCorrectChime();
    }
    widget.onPieceSelected(option, option.isCorrect);
  }

  String _emojiForLevel(GameLevelEntity level) {
    for (final entry in _themeEmojis.entries) {
      if (level.referenceImage?.contains(entry.key) == true ||
          level.relatedConcepts.any((c) => c.contains(entry.key))) {
        return entry.value;
      }
    }
    final values = _themeEmojis.values.toList();
    return values[level.levelNumber % values.length];
  }

  static const _themeEmojis = {
    'cow': '🐄',
    'sheep': '🐑',
    'pig': '🐖',
    'lion': '🦁',
    'elephant': '🐘',
    'giraffe': '🦒',
    'monkey': '🐵',
    'rocket': '🚀',
    'dino': '🦕',
    'tree': '🌳',
    'tail': '🦴',
    'head': '🙂',
    'ear': '👂',
    'hoof': '🦶',
  };

  String _emojiForOption(LevelOption option) {
    // Prefer theme from image filename — never show ✅ as a choice face.
    if (option.image.isNotEmpty) {
      final id = option.image
          .split('/')
          .last
          .replaceAll('.png', '')
          .replaceAll('_full', '');
      final fromTheme = _themeEmojis[id];
      if (fromTheme != null) return fromTheme;
    }
    final fromId = _themeEmojis[option.id];
    if (fromId != null) return fromId;
    return '🧩';
  }

  String _labelForOption(LevelOption option) {
    if (option.image.isNotEmpty) {
      final name = option.image
          .split('/')
          .last
          .replaceAll('.png', '')
          .replaceAll('_full', '');
      if (name.isNotEmpty && name != 'correct' && !name.startsWith('wrong')) {
        return name;
      }
    }
    final key = option.labelKey ?? option.id;
    if (key == 'correct' || key.startsWith('wrong')) return 'piece';
    return key;
  }
}

/// Engine 11: Riddle / What Am I?
class RiddleEngine extends StatefulWidget {
  const RiddleEngine({
    super.key,
    required this.clues,
    required this.choices,
    required this.answerId,
    required this.onGuess,
  });

  final List<String> clues;
  final List<Map<String, dynamic>> choices;
  final String answerId;
  final void Function(String choiceId, int cluesUsed) onGuess;

  @override
  State<RiddleEngine> createState() => _RiddleEngineState();
}

class _RiddleEngineState extends State<RiddleEngine> {
  int _clueIndex = 0;

  @override
  Widget build(BuildContext context) {
    final visibleClues = widget.clues.take(_clueIndex + 1).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...visibleClues.map(
          (c) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌟 ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    c,
                    style: const TextStyle(fontSize: 17, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_clueIndex < widget.clues.length - 1)
          TextButton(
            onPressed: () => setState(() => _clueIndex++),
            child: const Text('Need another clue?'),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: widget.choices.map((c) {
            return CartoonChoiceCard(
              emoji: c['emoji'] as String? ?? '❓',
              imagePath: c['imagePath'] as String?,
              label: c['label'] as String? ?? '',
              minSize: Responsive.touchTarget(context),
              onTap: () => widget.onGuess(c['id'] as String, _clueIndex + 1),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.emoji,
    required this.label,
  });

  final String emoji;
  final String label;
  static const _minSize = 72.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _minSize + 20,
      height: _minSize + 20,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: _minSize * 0.45)),
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 60),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, style: const TextStyle(fontSize: 17)),
      ),
    );
  }
}

Color _readableAccent(BuildContext context, Color accent) {
  final onSurface = Theme.of(context).textTheme.bodyLarge?.color;
  if (onSurface != null && onSurface.computeLuminance() > 0.6) {
    return onSurface;
  }
  return accent;
}
