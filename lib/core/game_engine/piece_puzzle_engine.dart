import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/assets/game_image_resolver.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/presentation/widgets/cartoon_game_widgets.dart';

/// One high-quality image split into a real 2×2 jigsaw (interlocking knobs).
class PiecePuzzleEngine extends StatefulWidget {
  const PiecePuzzleEngine({
    super.key,
    required this.level,
    required this.onComplete,
    this.accentColor,
    this.prompt = 'Put the pieces together! 🧩',
  });

  final GameLevelEntity level;
  final VoidCallback onComplete;
  final Color? accentColor;
  final String prompt;

  @override
  State<PiecePuzzleEngine> createState() => _PiecePuzzleEngineState();
}

class _PiecePuzzleEngineState extends State<PiecePuzzleEngine> {
  static const _rows = 2;
  static const _cols = 2;

  late String _imagePath;
  late String _themeEmoji;
  late int _colorVariant;
  late List<_PuzzlePiece> _tray;
  final Map<String, _PuzzlePiece> _placed = {};
  bool _done = false;
  ui.Image? _decoded;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void didUpdateWidget(covariant PiecePuzzleEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.id != widget.level.id) {
      _bootstrap();
    }
  }

  void _bootstrap() {
    _imagePath = _resolveImage(widget.level);
    _themeEmoji = _emojiFor(widget.level);
    _colorVariant = widget.level.extra['colorVariant'] as int? ?? 0;
    _tray = _buildPieces()..shuffle(math.Random(widget.level.levelNumber));
    _placed.clear();
    _done = false;
    _decoded = null;
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final data = await rootBundle.load(_imagePath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 512,
        targetHeight: 512,
      );
      final frame = await codec.getNextFrame();
      if (mounted) setState(() => _decoded = frame.image);
    } catch (_) {
      // Painter falls back to emoji.
    }
  }

  List<_PuzzlePiece> _buildPieces() => [
        for (var r = 0; r < _rows; r++)
          for (var c = 0; c < _cols; c++)
            _PuzzlePiece(id: 'p_${r}_$c', row: r, col: c),
      ];

  String _resolveImage(GameLevelEntity level) {
    final fromRef = GameImageResolver.themeFromLevel(
      referenceImage: level.referenceImage,
      relatedConcepts: level.relatedConcepts,
    );
    if (fromRef != null) return fromRef;
    for (final o in level.options) {
      if (o.isCorrect) {
        final path = GameImageResolver.assetFromImagePath(o.image);
        if (path != null) return path;
      }
    }
    return 'assets/images/game/animals/sheep.png';
  }

  String _emojiFor(GameLevelEntity level) {
    const map = {
      'cow': '🐄', 'sheep': '🐑', 'pig': '🐖', 'lion': '🦁', 'elephant': '🐘',
      'giraffe': '🦒', 'monkey': '🐵', 'rocket': '🚀', 'bear': '🐻', 'duck': '🦆',
      'frog': '🐸', 'horse': '🐴', 'chicken': '🐓', 'penguin': '🐧', 'shark': '🦈',
      'butterfly': '🦋', 'trex': '🦖', 'triceratops': '🦕', 'stego': '🦴',
      'brachio': '🦕', 'veloci': '🦖', 'ptero': '🦅', 'ankylo': '🦴', 'spino': '🦖',
      'sun': '☀️', 'moon': '🌙', 'earth': '🌍', 'mars': '🔴', 'saturn': '🪐',
      'star': '⭐', 'comet': '☄️', 'football': '⚽', 'basketball': '🏀',
      'tennis': '🎾', 'swimming': '🏊', 'cricket': '🏏', 'golf': '⛳', 'skiing': '⛷️',
      'hammer': '🔨', 'wrench': '🔧', 'screwdriver': '🪛', 'saw': '🪚', 'drill': '🔩',
      'pliers': '🔧', 'red': '🔴', 'blue': '🔵', 'green': '🟢', 'yellow': '🟡',
      'orange': '🟠', 'purple': '🟣', 'pink': '🩷', 'black': '⚫', 'white': '⚪',
    };
    final ref = level.referenceImage ?? '';
    for (final e in map.entries) {
      if (ref.contains(e.key) ||
          level.relatedConcepts.any((c) => c.contains(e.key))) {
        return e.value;
      }
    }
    if (ref.contains('letter_')) {
      return ref.split('letter_').last.replaceAll('.png', '').toUpperCase();
    }
    if (ref.contains('num_')) {
      return ref.split('num_').last.replaceAll('.png', '');
    }
    return '🧩';
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF7E57C2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.7;
        final w = constraints.maxWidth;
        final compact = h < 560;
        final boardSize =
            (math.min(w - 32, h * 0.40)).clamp(148.0, 220.0).toDouble();
        final trayPad = 10.0;
        final trayGap = 4.0;
        final trayPiece =
            ((w - trayPad * 2 - trayGap * 3) / 4).clamp(52.0, 70.0);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
              child: CartoonPromptBubble(
                text: widget.prompt,
                accent: accent,
                compact: true,
              ),
            ),
            Expanded(
              child: Center(
                child: _PuzzleBoard(
                  size: boardSize,
                  accent: accent,
                  image: _decoded,
                  themeEmoji: _themeEmoji,
                  colorVariant: _colorVariant,
                  placed: _placed,
                  done: _done,
                  onPieceDropped: _tryPlacePiece,
                ),
              ),
            ),
            Text(
              'Drag each piece to its spot!',
              style: GoogleFonts.fredoka(
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
            const SizedBox(height: 6),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(trayPad, 0, trayPad, 8),
                child: SizedBox(
                  height: trayPiece + 8,
                  child: Row(
                    children: List.generate(4, (i) {
                      if (i >= _tray.length) {
                        return const Expanded(child: SizedBox.shrink());
                      }
                      final piece = _tray[i];
                      return Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: trayGap / 2),
                          child: Draggable<_PuzzlePiece>(
                            data: piece,
                            feedback: Material(
                              color: Colors.transparent,
                              elevation: 8,
                              shadowColor: accent.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: trayPiece,
                                height: trayPiece,
                                child: _JigsawTile(
                                  row: piece.row,
                                  col: piece.col,
                                  image: _decoded,
                                  fallbackEmoji: _themeEmoji,
                                  accent: accent,
                                  selected: true,
                                  showBorder: true,
                                  colorVariant: _colorVariant,
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.25,
                              child: OverflowBox(
                                maxHeight: trayPiece + 14,
                                child: SizedBox(
                                  height: trayPiece,
                                  child: _JigsawTile(
                                    row: piece.row,
                                    col: piece.col,
                                    image: _decoded,
                                    fallbackEmoji: _themeEmoji,
                                    accent: accent,
                                    selected: false,
                                    showBorder: true,
                                    colorVariant: _colorVariant,
                                  ),
                                ),
                              ),
                            ),
                            child: OverflowBox(
                              maxHeight: trayPiece + 14,
                              child: SizedBox(
                                height: trayPiece,
                                child: _JigsawTile(
                                  row: piece.row,
                                  col: piece.col,
                                  image: _decoded,
                                  fallbackEmoji: _themeEmoji,
                                  accent: accent,
                                  selected: false,
                                  showBorder: true,
                                  colorVariant: _colorVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _tryPlacePiece(_PuzzlePiece piece, int row, int col) {
    if (_done) return;

    final slotKey = '$row,$col';
    if (_placed.containsKey(slotKey)) return;

    if (piece.row == row && piece.col == col) {
      setState(() {
        _placed[slotKey] = piece;
        _tray.removeWhere((p) => p.id == piece.id);
      });
      getIt<SoundManager>().playCorrectChime();
      if (_placed.length >= _rows * _cols) {
        setState(() => _done = true);
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) widget.onComplete();
        });
      }
    } else {
      getIt<SoundManager>().playSfx('soft_boop');
    }
  }
}

class _PuzzlePiece {
  const _PuzzlePiece({required this.id, required this.row, required this.col});
  final String id;
  final int row;
  final int col;
}

class _PuzzleBoard extends StatelessWidget {
  const _PuzzleBoard({
    required this.size,
    required this.accent,
    required this.image,
    required this.themeEmoji,
    required this.colorVariant,
    required this.placed,
    required this.done,
    required this.onPieceDropped,
  });

  final double size;
  final Color accent;
  final ui.Image? image;
  final String themeEmoji;
  final int colorVariant;
  final Map<String, _PuzzlePiece> placed;
  final bool done;
  final void Function(_PuzzlePiece piece, int row, int col) onPieceDropped;

  @override
  Widget build(BuildContext context) {
    // Extra pad so jigsaw knobs aren't clipped.
    final pad = size * 0.08;
    return Container(
      width: size + pad * 2,
      height: size + pad * 2,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.28),
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: List.generate(2, (row) {
          return Expanded(
            child: Row(
              children: List.generate(2, (col) {
                final key = '$row,$col';
                final piece = placed[key];
                return Expanded(
                  child: piece != null
                      ? _JigsawTile(
                          row: piece.row,
                          col: piece.col,
                          image: image,
                          fallbackEmoji: themeEmoji,
                          accent: accent,
                          selected: false,
                          showBorder: false,
                          colorVariant: colorVariant,
                        )
                      : DragTarget<_PuzzlePiece>(
                          onWillAcceptWithDetails: (details) =>
                              !done && !placed.containsKey(key),
                          onAcceptWithDetails: (details) =>
                              onPieceDropped(details.data, row, col),
                          builder: (context, candidate, rejected) {
                            final hovering = candidate.isNotEmpty;
                            final piece =
                                hovering ? candidate.first as _PuzzlePiece : null;
                            final matches = piece != null &&
                                piece.row == row &&
                                piece.col == col;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: hovering
                                    ? (matches
                                        ? const Color(0xFFE8F5E9)
                                        : const Color(0xFFFFEBEE))
                                    : accent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: hovering
                                      ? (matches
                                          ? const Color(0xFF66BB6A)
                                          : const Color(0xFFE57373))
                                      : accent.withValues(alpha: 0.55),
                                  width: hovering ? 3 : 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  hovering ? (matches ? '✓' : '✗') : '?',
                                  style: GoogleFonts.fredoka(
                                    fontSize: size * 0.12,
                                    color: hovering
                                        ? (matches
                                            ? const Color(0xFF43A047)
                                            : const Color(0xFFE53935))
                                        : accent.withValues(alpha: 0.45),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

/// Classic jigsaw tile: round tabs / sockets by row+col.
class _JigsawTile extends StatelessWidget {
  const _JigsawTile({
    required this.row,
    required this.col,
    required this.image,
    required this.fallbackEmoji,
    required this.accent,
    required this.selected,
    required this.showBorder,
    this.colorVariant = 0,
  });

  final int row;
  final int col;
  final ui.Image? image;
  final String fallbackEmoji;
  final Color accent;
  final bool selected;
  final bool showBorder;
  final int colorVariant;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JigsawPiecePainter(
        row: row,
        col: col,
        image: image,
        accent: accent,
        selected: selected,
        showBorder: showBorder,
        fallbackEmoji: fallbackEmoji,
        colorVariant: colorVariant,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _JigsawPiecePainter extends CustomPainter {
  _JigsawPiecePainter({
    required this.row,
    required this.col,
    required this.image,
    required this.accent,
    required this.selected,
    required this.showBorder,
    required this.fallbackEmoji,
    this.colorVariant = 0,
  });

  final int row;
  final int col;
  final ui.Image? image;
  final Color accent;
  final bool selected;
  final bool showBorder;
  final String fallbackEmoji;
  final int colorVariant;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _JigsawPathBuilder.build(size: size, row: row, col: col);

    canvas.save();
    canvas.clipPath(path);

    if (image != null) {
      final src = Rect.fromLTWH(
        col * image!.width / 2,
        row * image!.height / 2,
        image!.width / 2,
        image!.height / 2,
      );
      final dst = Rect.fromLTWH(0, 0, size.width, size.height);
      final paint = Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true;
      final filter = _PuzzleColorVariant.filter(colorVariant);
      if (filter != null) {
        paint.colorFilter = filter;
      }
      canvas.drawImageRect(image!, src, dst, paint);
    } else {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = const Color(0xFFF3E5F5),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: fallbackEmoji,
          style: TextStyle(fontSize: size.shortestSide * 0.4),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }
    canvas.restore();

    canvas.drawPath(
      path,
      Paint()
        ..color = selected ? accent : accent.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 3.5 : (showBorder ? 2.5 : 1.8)
        ..isAntiAlias = true,
    );

    if (selected) {
      canvas.drawPath(
        path,
        Paint()
          ..color = accent.withValues(alpha: 0.18)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JigsawPiecePainter oldDelegate) =>
      oldDelegate.image != image ||
      oldDelegate.selected != selected ||
      oldDelegate.row != row ||
      oldDelegate.col != col ||
      oldDelegate.colorVariant != colorVariant;
}

/// Tint presets so the same base PNG can appear in multiple unique puzzles.
class _PuzzleColorVariant {
  static ColorFilter? filter(int variant) {
    switch (variant) {
      case 0:
        return null;
      case 1:
        return const ColorFilter.matrix([
          1.08, 0.12, 0.0, 0, 12,
          0.05, 0.95, 0.0, 0, 8,
          0.0, 0.08, 0.92, 0, 4,
          0, 0, 0, 1, 0,
        ]);
      case 2:
        return const ColorFilter.matrix([
          0.82, 0.08, 0.18, 0, 6,
          0.06, 0.88, 0.16, 0, 6,
          0.12, 0.18, 1.08, 0, 10,
          0, 0, 0, 1, 0,
        ]);
      case 3:
        return const ColorFilter.matrix([
          0.92, 0.18, 0.08, 0, 8,
          0.08, 1.02, 0.08, 0, 8,
          0.08, 0.08, 0.92, 0, 8,
          0, 0, 0, 1, 0,
        ]);
      case 4:
        return const ColorFilter.matrix([
          1.12, 0.0, 0.0, 0, 14,
          0.0, 1.08, 0.0, 0, 10,
          0.0, 0.0, 0.88, 0, 6,
          0, 0, 0, 1, 0,
        ]);
      default:
        return const ColorFilter.matrix([
          0.88, 0.12, 0.22, 0, 10,
          0.10, 0.86, 0.22, 0, 10,
          0.18, 0.12, 1.10, 0, 12,
          0, 0, 0, 1, 0,
        ]);
    }
  }
}

/// Builds interlocking jigsaw outlines for a 2×2 piece.
class _JigsawPathBuilder {
  static Path build({
    required Size size,
    required int row,
    required int col,
  }) {
    final w = size.width;
    final h = size.height;
    final knob = math.min(w, h) * 0.18;

    // Tab directions for classic 2×2 interlocking:
    // (0,0) tabs right+bottom; (0,1) socket left + tab bottom;
    // (1,0) tab right + socket top; (1,1) sockets left+top.
    final tabRight = col == 0;
    final tabBottom = row == 0;
    final socketLeft = col == 1;
    final socketTop = row == 1;

    final path = Path();
    path.moveTo(0, 0);

    // Top edge
    if (socketTop) {
      _edgeWithKnob(path, Offset(0, 0), Offset(w, 0), knob, outward: false);
    } else {
      path.lineTo(w, 0);
    }

    // Right edge
    if (tabRight) {
      _edgeWithKnob(path, Offset(w, 0), Offset(w, h), knob, outward: true);
    } else {
      path.lineTo(w, h);
    }

    // Bottom edge (right → left)
    if (tabBottom) {
      _edgeWithKnob(path, Offset(w, h), Offset(0, h), knob, outward: true);
    } else {
      path.lineTo(0, h);
    }

    // Left edge (bottom → top)
    if (socketLeft) {
      _edgeWithKnob(path, Offset(0, h), Offset(0, 0), knob, outward: false);
    } else {
      path.lineTo(0, 0);
    }

    path.close();
    return path;
  }

  /// Draws an edge from [a] to [b] with a circular knob in the middle.
  /// [outward] true = tab (protrudes), false = socket (indents).
  static void _edgeWithKnob(
    Path path,
    Offset a,
    Offset b,
    double knob, {
    required bool outward,
  }) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len < 1) {
      path.lineTo(b.dx, b.dy);
      return;
    }
    final ux = dx / len;
    final uy = dy / len;
    // Perpendicular (rotate 90°)
    var nx = -uy;
    var ny = ux;
    if (!outward) {
      nx = -nx;
      ny = -ny;
    }

    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final neck = knob * 0.55;
    final startKnob = Offset(mid.dx - ux * neck, mid.dy - uy * neck);
    final endKnob = Offset(mid.dx + ux * neck, mid.dy + uy * neck);
    final tip = Offset(mid.dx + nx * knob, mid.dy + ny * knob);

    path.lineTo(startKnob.dx, startKnob.dy);
    path.quadraticBezierTo(
      mid.dx + nx * knob * 0.15 - uy * knob * 0.35,
      mid.dy + ny * knob * 0.15 + ux * knob * 0.35,
      tip.dx,
      tip.dy,
    );
    path.quadraticBezierTo(
      mid.dx + nx * knob * 0.15 + uy * knob * 0.35,
      mid.dy + ny * knob * 0.15 - ux * knob * 0.35,
      endKnob.dx,
      endKnob.dy,
    );
    path.lineTo(b.dx, b.dy);
  }
}
