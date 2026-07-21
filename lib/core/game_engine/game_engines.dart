import 'package:flutter/material.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
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

  @override
  void didUpdateWidget(covariant TapMatchEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.choices != widget.choices ||
        oldWidget.prompt != widget.prompt) {
      _selectedId = null;
      _bounceTrigger = 0;
      _locked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final touch = Responsive.touchTarget(context);
    final accent = widget.accentColor ?? const Color(0xFF5C6BC0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CartoonPromptBubble(text: widget.prompt, accent: accent),
        if (widget.target != null) ...[
          const SizedBox(height: 12),
          CartoonTargetHero(
            label: widget.target!['label'] as String? ?? '',
            emoji: widget.target!['emoji'] as String?,
            imagePath: widget.target!['imagePath'] as String?,
            accent: accent,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the matching one below!',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ] else ...[
          const SizedBox(height: 4),
          Text(
            'Listen & tap the right animal!',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: widget.choices.map((c) {
            final id = c['id'] as String;
            final isCorrect = c['isCorrect'] as bool? ?? id == widget.correctId;
            final showGlow = widget.showHint &&
                (widget.hintOptionId == id || (isCorrect && widget.hintOptionId == null));
            return BounceBackAnimation(
              trigger: _selectedId == id && !isCorrect ? _bounceTrigger : 0,
              child: ScaffoldHintGlow(
                showGlow: showGlow,
                child: CartoonChoiceCard(
                  emoji: c['emoji'] as String? ?? '❓',
                  imagePath: c['imagePath'] as String?,
                  label: c['label'] as String? ?? '',
                  minSize: touch,
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
    );
  }

  void _onTap(String id, bool isCorrect) {
    setState(() => _selectedId = id);
    if (!isCorrect) {
      setState(() => _bounceTrigger++);
      widget.onChoice(id, false);
      return;
    }
    setState(() => _locked = true);
    widget.onChoice(id, true);
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
  });

  final String prompt;
  final Map<String, dynamic> target;
  final List<Map<String, dynamic>> choices;
  final void Function(String choiceId, bool isCorrect) onChoice;
  final bool showHint;
  final String? hintOptionId;
  final Color? accentColor;

  @override
  State<NameMatchEngine> createState() => _NameMatchEngineState();
}

class _NameMatchEngineState extends State<NameMatchEngine> {
  String? _selectedId;
  int _bounceTrigger = 0;
  bool _locked = false;

  @override
  void didUpdateWidget(covariant NameMatchEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.choices != widget.choices ||
        oldWidget.prompt != widget.prompt) {
      _selectedId = null;
      _bounceTrigger = 0;
      _locked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final touch = Responsive.touchTarget(context);
    final accent = widget.accentColor ?? const Color(0xFF4CAF50);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CartoonPromptBubble(text: widget.prompt, accent: accent),
        const SizedBox(height: 12),
        CartoonTargetHero(
          label: '',
          emoji: widget.target['emoji'] as String?,
          imagePath: widget.target['imagePath'] as String?,
          accent: accent,
          hideLabel: true,
        ),
        const SizedBox(height: 8),
        Text(
          'Pick the right name!',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: widget.choices.map((c) {
            final id = c['id'] as String;
            final isCorrect = c['isCorrect'] as bool? ?? false;
            final showGlow = widget.showHint && widget.hintOptionId == id;
            return BounceBackAnimation(
              trigger: _selectedId == id && !isCorrect ? _bounceTrigger : 0,
              child: ScaffoldHintGlow(
                showGlow: showGlow,
                child: CartoonChoiceCard(
                  label: c['label'] as String? ?? id,
                  minSize: touch,
                  borderColor: accent,
                  textOnly: true,
                  selected: _selectedId == id && isCorrect,
                  onTap: _locked ? null : () => _onTap(id, isCorrect),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onTap(String id, bool isCorrect) {
    setState(() => _selectedId = id);
    if (!isCorrect) {
      setState(() => _bounceTrigger++);
      widget.onChoice(id, false);
      return;
    }
    setState(() => _locked = true);
    widget.onChoice(id, true);
  }
}

/// Engine 3: Drag & Drop
class DragDropEngine extends StatelessWidget {
  const DragDropEngine({
    super.key,
    required this.draggableItem,
    required this.targets,
    required this.onDropped,
  });

  final Map<String, dynamic> draggableItem;
  final List<Map<String, dynamic>> targets;
  final void Function(String targetId, bool isCorrect) onDropped;

  @override
  Widget build(BuildContext context) {
    final targetSize = Responsive.scale(context, 100.0, 120.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<String>(
          data: draggableItem['id'] as String,
          feedback: Material(
            color: Colors.transparent,
            child: _ItemCard(
              emoji: draggableItem['emoji'] as String? ?? '📦',
              label: draggableItem['label'] as String? ?? '',
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _ItemCard(
              emoji: draggableItem['emoji'] as String? ?? '📦',
              label: draggableItem['label'] as String? ?? '',
            ),
          ),
          child: _ItemCard(
            emoji: draggableItem['emoji'] as String? ?? '📦',
            label: draggableItem['label'] as String? ?? '',
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: targets.map((t) {
            return DragTarget<String>(
              onAcceptWithDetails: (details) {
                onDropped(
                  t['id'] as String,
                  details.data == t['acceptsId'],
                );
              },
              builder: (context, candidate, rejected) {
                return Container(
                  width: targetSize,
                  height: targetSize,
                  decoration: BoxDecoration(
                    color: candidate.isNotEmpty
                        ? AppTheme.success.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: candidate.isNotEmpty
                          ? AppTheme.success
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t['emoji'] as String? ?? '📥',
                        style: TextStyle(fontSize: targetSize * 0.28),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          t['label'] as String? ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
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
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 400;
            final children = [
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
            ];
            return Row(children: children);
          },
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
            separatorBuilder: (_, _i) => const SizedBox(width: 4),
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

/// Engine 9: Simon Says / Memory Sequence
class SimonEngine extends StatefulWidget {
  const SimonEngine({
    super.key,
    required this.sequence,
    required this.colors,
    required this.onComplete,
  });

  final List<int> sequence;
  final List<Color> colors;
  final void Function(bool success) onComplete;

  @override
  State<SimonEngine> createState() => _SimonEngineState();
}

class _SimonEngineState extends State<SimonEngine> {
  int _playerIndex = 0;
  int? _highlighted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth.clamp(200.0, 400.0);
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(widget.colors.length, (i) {
                return GestureDetector(
                  onTap: () => _onPadTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _highlighted == i
                          ? widget.colors[i]
                          : widget.colors[i].withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  void _onPadTap(int index) {
    if (widget.sequence[_playerIndex] == index) {
      setState(() {
        _playerIndex++;
        _highlighted = index;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _highlighted = null);
      });
      if (_playerIndex >= widget.sequence.length) {
        widget.onComplete(true);
      }
    } else {
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
        final boardSize = (constraints.maxWidth * 0.62).clamp(160.0, 260.0);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: CartoonPromptBubble(
                text: widget.prompt,
                accent: accent,
              ),
            ),
            Expanded(
              child: Center(
                child: CartoonPuzzleBoard(
                  rows: widget.level.boardRows,
                  cols: widget.level.boardCols,
                  missingSlots: widget.level.missingSlots,
                  themeImagePath: themeImage,
                  themeEmoji: themeEmoji,
                  accent: accent,
                  size: boardSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: widget.level.options.map((option) {
                  final showHint = widget.hintOptionId == option.id;
                  final imagePath = GameImageResolver.assetFromImagePath(
                        option.image,
                      ) ??
                      GameImageResolver.assetForId(option.id);
                  return BounceBackAnimation(
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
                        selected: _selectedId == option.id && option.isCorrect,
                        onTap: () => _onSelect(option),
                      ),
                    ),
                  );
                }).toList(),
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
    }
    widget.onPieceSelected(option, option.isCorrect);
  }

  String _emojiForLevel(GameLevelEntity level) {
    const emojis = {
      'cow': '🐄', 'sheep': '🐑', 'pig': '🐖', 'lion': '🦁',
      'elephant': '🐘', 'giraffe': '🦒', 'monkey': '🐵', 'rocket': '🚀',
      'dino': '🦕', 'tree': '🌳',
    };
    for (final key in emojis.keys) {
      if (level.referenceImage?.contains(key) == true ||
          level.relatedConcepts.any((c) => c.contains(key))) {
        return emojis[key]!;
      }
    }
    return emojis.values.elementAt(level.levelNumber % emojis.length);
  }

  String _emojiForOption(LevelOption option) {
    final fromImage = GameImageResolver.assetFromImagePath(option.image);
    if (fromImage != null) {
      final id = option.image.split('/').last.replaceAll('.png', '');
      const map = {
        'cow': '🐄', 'sheep': '🐑', 'pig': '🐖', 'lion': '🦁',
        'elephant': '🐘', 'giraffe': '🦒', 'monkey': '🐵', 'rocket': '🚀',
        'dino': '🦕', 'tree': '🌳',
      };
      return map[id] ?? '🔲';
    }
    const map = {
      'correct': '✅', 'wrong_1': '🔲', 'wrong_2': '🔲',
      'tail': '🦴', 'head': '🙂', 'ear': '👂', 'hoof': '🦶',
    };
    return map[option.id] ?? '🔲';
  }

  String _labelForOption(LevelOption option) {
    if (option.image.isNotEmpty) {
      return option.image.split('/').last.replaceAll('.png', '');
    }
    return option.labelKey ?? option.id;
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
    this.minSize = 72,
  });

  final String emoji;
  final String label;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: minSize + 20,
      height: minSize + 20,
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
          Text(emoji, style: TextStyle(fontSize: minSize * 0.45)),
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
