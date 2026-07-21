import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';

/// Cartoon-styled choice card for kids games — thick border, bounce shadow, image or emoji.
class CartoonChoiceCard extends StatefulWidget {
  const CartoonChoiceCard({
    super.key,
    required this.label,
    this.emoji,
    this.imagePath,
    this.minSize = 88,
    this.borderColor,
    this.onTap,
    this.selected = false,
    this.textOnly = false,
  });

  final String label;
  final String? emoji;
  final String? imagePath;
  final double minSize;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool selected;
  final bool textOnly;

  @override
  State<CartoonChoiceCard> createState() => _CartoonChoiceCardState();
}

class _CartoonChoiceCardState extends State<CartoonChoiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final border = widget.borderColor ?? const Color(0xFF5C6BC0);
    final size = widget.minSize + 28;
    final lift = _pressed ? 2.0 : 6.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size + 8,
        transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: size,
                decoration: BoxDecoration(
                  color: widget.selected
                      ? border.withValues(alpha: 0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: widget.selected ? border : border.withValues(alpha: 0.7),
                    width: widget.selected ? 4 : 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: border.withValues(alpha: 0.35),
                      offset: Offset(0, lift),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _buildContent(size),
                ),
              ),
            ),
            if (widget.label.isNotEmpty) ...[
              const SizedBox(height: 4),
              SizedBox(
                width: size + 8,
                child: Text(
                  _prettyLabel(widget.label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(double size) {
    if (widget.textOnly) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _prettyLabel(widget.label),
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: size * 0.24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3142),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.imagePath != null) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          widget.imagePath!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _emojiFallback(size),
        ),
      );
    }
    return _emojiFallback(size);
  }

  Widget _emojiFallback(double size) {
    return Center(
      child: Text(
        widget.emoji ?? '❓',
        style: TextStyle(fontSize: size * 0.38),
      ),
    );
  }

  String _prettyLabel(String raw) {
    if (raw.startsWith('letter_')) return raw.replaceAll('letter_', '').toUpperCase();
    if (raw.startsWith('num_')) return raw.replaceAll('num_', '');
    return raw.replaceAll('_', ' ');
  }
}

/// Big cartoon prompt bubble at top of games.
class CartoonPromptBubble extends StatelessWidget {
  const CartoonPromptBubble({
    super.key,
    required this.text,
    this.accent,
  });

  final String text;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF6C63FF);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3142),
          height: 1.25,
        ),
      ),
    );
  }
}

/// Shows what the child should find — big friendly hero card.
class CartoonTargetHero extends StatelessWidget {
  const CartoonTargetHero({
    super.key,
    required this.label,
    this.emoji,
    this.imagePath,
    this.accent,
    this.hideLabel = false,
  });

  final String label;
  final String? emoji;
  final String? imagePath;
  final Color? accent;
  final bool hideLabel;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF6C63FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color, width: 3),
      ),
      child: Column(
        children: [
          Text(
            'Find this!',
            style: GoogleFonts.baloo2(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 88,
            child: imagePath != null
                ? Image.asset(imagePath!, fit: BoxFit.contain)
                : Text(emoji ?? '❓', style: const TextStyle(fontSize: 72)),
          ),
          if (label.isNotEmpty && !hideLabel) ...[
            const SizedBox(height: 4),
            Text(
              label.replaceAll('_', ' '),
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Zone-themed game screen wrapper.
class ZoneGameScaffold extends StatelessWidget {
  const ZoneGameScaffold({
    super.key,
    required this.zoneId,
    required this.title,
    required this.body,
    this.onBack,
  });

  final String? zoneId;
  final String title;
  final Widget body;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = ZoneVisualTheme.forZone(zoneId ?? 'jungle_grove');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w700,
            color: theme.appBarForeground,
          ),
        ),
        foregroundColor: theme.appBarForeground,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ZoneThemedBackground(
        theme: theme,
        child: SafeArea(child: body),
      ),
    );
  }
}

/// Cartoon level progress bar for puzzle/drawing screens.
class CartoonProgressBar extends StatelessWidget {
  const CartoonProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.accent,
    this.label,
  });

  final int current;
  final int total;
  final Color? accent;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF7E57C2);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          Text(
            label ?? 'Level $current / $total',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: current / total,
                backgroundColor: Colors.white,
                color: color,
                minHeight: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill toggle for Color / Draw modes.
class CartoonPillToggle extends StatelessWidget {
  const CartoonPillToggle({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.accent,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF42A5F5);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 3),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.baloo2(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

/// Color swatch for Drawing Den palette.
class CartoonColorSwatch extends StatelessWidget {
  const CartoonColorSwatch({
    super.key,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? const Color(0xFF2D3142) : Colors.white,
            width: selected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: Offset(0, selected ? 2 : 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}

/// Thick-bordered canvas frame for drawing/coloring.
class CartoonCanvasFrame extends StatelessWidget {
  const CartoonCanvasFrame({
    super.key,
    required this.child,
    this.accent,
  });

  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF42A5F5);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color, width: 4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }
}

/// SVG template thumbnail for Drawing Den picker.
class CartoonTemplateThumb extends StatelessWidget {
  const CartoonTemplateThumb({
    super.key,
    required this.label,
    required this.thumbnail,
    required this.selected,
    required this.onTap,
    this.accent,
  });

  final String label;
  final Widget thumbnail;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF42A5F5);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 92,
        height: 88,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.4),
            width: selected ? 3 : 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Expanded(child: thumbnail),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.baloo2(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? color : const Color(0xFF2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3×3 cartoon puzzle board with missing piece slots.
class CartoonPuzzleBoard extends StatelessWidget {
  const CartoonPuzzleBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.missingSlots,
    this.themeImagePath,
    this.themeEmoji = '🧩',
    this.accent,
    this.size,
  });

  final int rows;
  final int cols;
  final List<Map<String, int>> missingSlots;
  final String? themeImagePath;
  final String themeEmoji;
  final Color? accent;
  final double? size;

  bool _isMissing(int row, int col) {
    return missingSlots.any((s) => s['row'] == row && s['col'] == col);
  }

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF7E57C2);
    final boardSize = size ?? 220.0;
    final cellSize = boardSize / cols;

    return Container(
      width: boardSize + 8,
      height: boardSize + 8,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            offset: const Offset(0, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            children: List.generate(cols, (col) {
              final missing = _isMissing(row, col);
              return Container(
                width: cellSize,
                height: cellSize,
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: missing
                      ? color.withValues(alpha: 0.08)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: missing ? color : Colors.grey.shade300,
                    width: missing ? 2.5 : 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: missing
                    ? Center(
                        child: Text(
                          '?',
                          style: GoogleFonts.fredoka(
                            fontSize: cellSize * 0.45,
                            color: color.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : _filledCell(cellSize, row, col),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _filledCell(double cellSize, int row, int col) {
    // Show theme image in center cell, pattern elsewhere
    final isCenter = row == rows ~/ 2 && col == cols ~/ 2;
    if (isCenter && themeImagePath != null) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          themeImagePath!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: Text(themeEmoji, style: TextStyle(fontSize: cellSize * 0.4)),
          ),
        ),
      );
    }
    return Center(
      child: Opacity(
        opacity: 0.35,
        child: Text(themeEmoji, style: TextStyle(fontSize: cellSize * 0.28)),
      ),
    );
  }
}
