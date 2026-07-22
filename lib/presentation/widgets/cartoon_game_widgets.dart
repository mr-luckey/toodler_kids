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
    this.compact = false,
  });

  final String label;
  final String? emoji;
  final String? imagePath;
  final double minSize;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool selected;
  final bool textOnly;
  final bool compact;

  @override
  State<CartoonChoiceCard> createState() => _CartoonChoiceCardState();
}

class _CartoonChoiceCardState extends State<CartoonChoiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final border = widget.borderColor ?? const Color(0xFF5C6BC0);
    final pad = widget.compact ? 16.0 : 28.0;
    final size = widget.minSize + pad;
    final lift = _pressed ? 2.0 : (widget.compact ? 4.0 : 8.0);
    final selected = widget.selected;
    final radius = widget.compact ? 20.0 : 26.0;

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: size,
            height: size,
            transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        border.withValues(alpha: 0.22),
                        border.withValues(alpha: 0.08),
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFFFF8F0)],
                    ),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: selected ? border : border.withValues(alpha: 0.85),
                width: selected ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: border.withValues(alpha: selected ? 0.5 : 0.35),
                  offset: Offset(0, lift),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                if (!widget.compact)
                  Positioned(
                    top: 6,
                    left: 10,
                    right: 20,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius - 4),
                  child: _buildContent(size),
                ),
                if (selected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: border,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: widget.compact ? 12 : 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.label.isNotEmpty && !widget.textOnly) ...[
            SizedBox(height: widget.compact ? 4 : 6),
            SizedBox(
              width: size + 4,
              child: Text(
                _prettyLabel(widget.label),
                maxLines: widget.compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: widget.compact ? 12 : 14,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: const Color(0xFF2D3142),
                ),
              ),
            ),
          ],
        ],
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
      return Center(
        child: Image.asset(
          widget.imagePath!,
          fit: BoxFit.contain,
          width: size - 12,
          height: size - 12,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => _emojiFallback(size),
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

/// Big cartoon prompt bubble at top of games — speech-bubble sticker.
class CartoonPromptBubble extends StatelessWidget {
  const CartoonPromptBubble({
    super.key,
    required this.text,
    this.accent,
    this.compact = false,
  });

  final String text;
  final Color? accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF6C63FF);
    final iconSize = compact ? 34.0 : 44.0;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: compact ? 4 : 10),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 22,
        vertical: compact ? 10 : 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(compact ? 20 : 28),
        border: Border.all(color: color, width: compact ? 3 : 4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            offset: Offset(0, compact ? 4 : 7),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: compact ? 2 : 2.5),
            ),
            child: Center(
              child: Text(
                '💬',
                style: TextStyle(fontSize: compact ? 16 : 22),
              ),
            ),
          ),
          SizedBox(width: compact ? 10 : 12),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              maxLines: compact ? 2 : 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                fontSize: compact ? 16 : 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142),
                height: 1.2,
              ),
            ),
          ),
        ],
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
    this.header,
    this.displayLabel,
    this.compact = false,
    this.circleSize,
  });

  final String label;
  final String? emoji;
  final String? imagePath;
  final Color? accent;
  final bool hideLabel;
  final String? header;
  final String? displayLabel;
  final bool compact;
  final double? circleSize;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF6C63FF);
    final circle = circleSize ?? (compact ? 78.0 : 120.0);
    final emojiFs = circle * 0.52;
    final hPad = compact ? 14.0 : 22.0;
    final vPad = compact ? 10.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            Colors.white,
            color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(compact ? 24 : 32),
        border: Border.all(color: color, width: compact ? 3 : 4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            offset: Offset(0, compact ? 4 : 7),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 12,
              vertical: compact ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              header ?? 'Find this!',
              style: GoogleFonts.fredoka(
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: compact ? 6 : 10),
          Container(
            width: circle,
            height: circle,
            padding: EdgeInsets.all(compact ? 6 : 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: compact ? 2.5 : 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  )
                : Center(
                    child: Text(
                      emoji ?? '❓',
                      style: TextStyle(fontSize: emojiFs),
                    ),
                  ),
          ),
          if ((displayLabel ?? label).isNotEmpty && !hideLabel) ...[
            SizedBox(height: compact ? 4 : 8),
            Text(
              (displayLabel ?? label).replaceAll('_', ' '),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                fontSize: compact ? 16 : 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3142),
              ),
            ),
          ] else if (displayLabel != null && hideLabel) ...[
            SizedBox(height: compact ? 4 : 8),
            Text(
              displayLabel!.replaceAll('_', ' '),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                fontSize: compact ? 16 : 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shows a row of countable items for math levels.
class CartoonCountHero extends StatelessWidget {
  const CartoonCountHero({
    super.key,
    required this.count,
    required this.emoji,
    this.accent,
  });

  final int count;
  final String emoji;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF5C6BC0);
    final display = count.clamp(1, 12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color, width: 3),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: List.generate(
          display,
          (_) => Text(emoji, style: const TextStyle(fontSize: 36)),
        ),
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
        child: SafeArea(
          child: Theme(
            data: _themeForZone(context, theme),
            child: body,
          ),
        ),
      ),
    );
  }

  ThemeData _themeForZone(BuildContext context, ZoneVisualTheme theme) {
    final base = Theme.of(context);
    if (!theme.isDark) return base;
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: base.colorScheme.copyWith(
        onSurface: Colors.white,
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
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              offset: const Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label ?? 'Level $current / $total',
                    style: GoogleFonts.fredoka(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                ),
                Text(
                  '${((current / total) * 100).round()}%',
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.35), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: current / total,
                  backgroundColor: Colors.transparent,
                  color: color,
                  minHeight: 16,
                ),
              ),
            ),
          ],
        ),
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

/// 3×3 cartoon puzzle board — Expanded cells so it never overflows.
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
    final safeRows = rows.clamp(1, 6);
    final safeCols = cols.clamp(1, 6);

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Container(
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: List.generate(safeRows, (row) {
            return Expanded(
              child: Row(
                children: List.generate(safeCols, (col) {
                  final missing = _isMissing(row, col);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: missing
                              ? color.withValues(alpha: 0.1)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: missing ? color : Colors.grey.shade300,
                            width: missing ? 2.5 : 1.5,
                          ),
                        ),
                        child: missing
                            ? Center(
                                child: Text(
                                  '?',
                                  style: GoogleFonts.fredoka(
                                    fontSize: boardSize * 0.12,
                                    color: color.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : _filledCell(boardSize, row, col),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _filledCell(double boardSize, int row, int col) {
    final isCenter = row == rows ~/ 2 && col == cols ~/ 2;
    final emojiSize = boardSize * 0.11;
    if (isCenter && themeImagePath != null) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          themeImagePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(themeEmoji, style: TextStyle(fontSize: emojiSize * 1.2)),
          ),
        ),
      );
    }
    return Center(
      child: Opacity(
        opacity: 0.55,
        child: Text(themeEmoji, style: TextStyle(fontSize: emojiSize)),
      ),
    );
  }
}
