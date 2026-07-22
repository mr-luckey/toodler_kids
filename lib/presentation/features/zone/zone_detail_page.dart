import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/presentation/widgets/kid_ui.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';
import 'package:toodler_kids/presentation/features/game_play/game_play_page.dart';

class ZoneDetailPage extends StatefulWidget {
  const ZoneDetailPage({super.key, required this.zoneId});

  final String zoneId;

  @override
  State<ZoneDetailPage> createState() => _ZoneDetailPageState();
}

class _ZoneDetailPageState extends State<ZoneDetailPage> {
  ZoneEntity? _zone;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final zones = await GetZones(getIt())();
    if (!mounted) return;
    setState(() {
      _zone = zones.where((z) => z.id == widget.zoneId).firstOrNull;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = ZoneVisualTheme.forZone(widget.zoneId);
    final zone = _zone;
    final games = _visibleGames(zone?.gameTypes ?? []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _zoneTitle(widget.zoneId),
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w700),
        ),
        foregroundColor: theme.appBarForeground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ZoneThemedBackground(
        theme: theme,
        child: SafeArea(
          child: Responsive.centeredContent(
            context,
            ListView(
              padding: EdgeInsets.all(Responsive.pad(context)),
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.scale(context, 20, 28)),
                  decoration: BoxDecoration(
                    gradient: theme.hub,
                    borderRadius: BorderRadius.circular(
                      Responsive.cardRadius(context) + 6,
                    ),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.45),
                        offset: const Offset(0, 10),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: Responsive.scale(context, 88, 104),
                        height: Responsive.scale(context, 88, 104),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              _zoneEmoji(widget.zoneId),
                              style: TextStyle(
                                fontSize: Responsive.scale(context, 48, 60),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: MiniLottieSticker(
                                zoneId: widget.zoneId,
                                size: Responsive.scale(context, 28, 34),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _zoneTitle(widget.zoneId),
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontSize: Responsive.scale(context, 26, 32),
                          fontWeight: FontWeight.w700,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      if (zone != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${zone.levelCount}+ fun levels!',
                            style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...games.map(
                  (gameType) => KidGameTile(
                    emoji: _gameEmoji(gameType),
                    title: GamePlayPage.titleFor(gameType),
                    subtitle: _gameSubtitle(gameType),
                    color: theme.primary,
                    onTap: () => _openGame(context, gameType),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _visibleGames(List<String> gameTypes) {
    if (widget.zoneId == 'drawing_den') {
      return const ['coloring', 'free_draw'];
    }
    final seen = <String>{};
    final result = <String>[];
    for (final type in gameTypes) {
      if (type == 'coloring' || type == 'free_draw') continue;
      if (seen.add(type)) result.add(type);
    }
    return result;
  }

  void _openGame(BuildContext context, String gameType) {
    if (gameType == 'coloring' ||
        gameType == 'free_draw' ||
        widget.zoneId == 'drawing_den') {
      context.push('/drawing-den');
      return;
    }
    context.push('/game/play/$gameType?zone=${widget.zoneId}');
  }

  String _zoneTitle(String id) {
    const map = {
      'jungle_grove': 'Jungle Grove',
      'number_mountain': 'Number Mountain',
      'letter_lane': 'Letter Lane',
      'color_canyon': 'Color Canyon',
      'puzzle_palace': 'Puzzle Palace',
      'world_village': 'World Village',
      'music_meadow': 'Music Meadow',
      'opposites_ocean': 'Opposites Ocean',
      'dinosaurs': 'Dinosaur Zone',
      'space_science': 'Space Zone',
      'tools_professions': 'Tools Zone',
      'sports_body': 'Sports Zone',
      'seasons_holidays': 'Seasons Zone',
      'household_daily': 'Household Zone',
      'drawing_den': 'Drawing Den',
    };
    return map[id] ?? id;
  }

  String _zoneEmoji(String id) {
    const map = {
      'jungle_grove': '🌳',
      'number_mountain': '🔢',
      'letter_lane': '🔤',
      'color_canyon': '🌈',
      'puzzle_palace': '🧩',
      'world_village': '🌍',
      'music_meadow': '🎵',
      'opposites_ocean': '🔄',
      'dinosaurs': '🦕',
      'space_science': '🚀',
      'tools_professions': '🛠',
      'sports_body': '🏅',
      'seasons_holidays': '⛄',
      'household_daily': '🏠',
      'drawing_den': '🎨',
    };
    return map[id] ?? '⭐';
  }

  String _gameEmoji(String type) {
    const map = {
      'animal_world': '🦁',
      'animal_names': '📝',
      'number_recognition': '1️⃣',
      'counting': '🔢',
      'letter_recognition': '🔤',
      'letter_phonics': '🔊',
      'dino_names': '🦖',
      'space_objects': '🪐',
      'shadow_game': '👤',
      'complete_picture': '🧩',
      'what_am_i': '❓',
      'build_scene': '🏗️',
      'true_false_animals': '✅',
      'true_false_world': '🌍',
      'true_false_dino': '🦕',
      'true_false_space': '🚀',
      'which_tool_works': '🔧',
      'sports_names': '⚽',
      'four_seasons': '🌸',
      'household_items': '🏠',
      'fun_colors': '🎨',
      'color_recognition': '🌈',
      'opposites': '🔄',
      'simon_says': '🎵',
      'coloring': '🖍️',
      'free_draw': '✏️',
    };
    return map[type] ?? '🎮';
  }

  String _gameSubtitle(String type) {
    const map = {
      'animal_world': 'Quick tap — match the picture!',
      'animal_names': 'Picture quiz — pick the name!',
      'number_recognition': 'Find the number!',
      'counting': 'Count the stars — pick the number!',
      'letter_recognition': 'Find the letter!',
      'letter_phonics': 'Hear the sound — pick the letter!',
      'color_recognition': 'What color is this?',
      'fun_colors': 'Quick tap the color!',
      'complete_picture': '500 puzzle levels!',
      'shadow_game': 'Match the shadow!',
      'what_am_i': 'Solve fun riddles!',
      'build_scene': 'Build your own scene!',
      'true_false_animals': 'Animal facts quiz!',
      'opposites': 'Pick the opposite word!',
      'which_tool_works': 'Which tool fits the job?',
      'true_false_world': 'World geography & culture facts!',
      'true_false_space': 'Space science facts!',
      'space_objects': 'Learn space objects!',
      'dino_names': 'Name the dinosaur!',
      'four_seasons': 'Spot the season!',
      'household_items': 'Find household items!',
      'sports_names': 'Name the sport!',
      'simon_says': 'Copy the pattern!',
      'coloring': 'Tap to color pictures!',
      'free_draw': 'Draw anything!',
    };
    return map[type] ?? 'Let\'s play!';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
