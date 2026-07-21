import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
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
    final games = zone?.gameTypes ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_zoneTitle(widget.zoneId)),
        foregroundColor: theme.appBarForeground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ZoneThemedBackground(
        theme: theme,
        child: SafeArea(
          child: ListView(
          padding: EdgeInsets.all(Responsive.pad(context)),
          children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: theme.hub,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.cardBorderColor ?? theme.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.3),
                  offset: const Offset(0, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(_zoneEmoji(widget.zoneId),
                    style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 8),
                Text(
                  _zoneTitle(widget.zoneId),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (zone != null)
                  Text(
                    '${zone.levelCount}+ levels',
                    style: const TextStyle(color: Colors.white70),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (widget.zoneId == 'drawing_den')
            KidGameTile(
              emoji: '🎨',
              title: 'Drawing Den',
              subtitle: 'Color & draw freely',
              color: theme.primary,
              onTap: () => context.push('/drawing-den'),
            ),
          if (widget.zoneId == 'puzzle_palace') ...[
            KidGameTile(
              emoji: '🧩',
              title: 'Complete Picture',
              subtitle: '500 levels',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/complete_picture?zone=puzzle_palace',
              ),
            ),
            KidGameTile(
              emoji: '👤',
              title: 'Shadow Game',
              subtitle: '100 levels',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/shadow_game?zone=puzzle_palace',
              ),
            ),
          ],
          if (widget.zoneId == 'world_village') ...[
            KidGameTile(
              emoji: '❓',
              title: 'What Am I?',
              subtitle: '80 riddles',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/what_am_i?zone=world_village',
              ),
            ),
            KidGameTile(
              emoji: '🏗️',
              title: 'Build a Scene',
              subtitle: 'Creative play',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/build_scene?zone=world_village',
              ),
            ),
            KidGameTile(
              emoji: '✅',
              title: 'True or False',
              subtitle: 'Animal facts',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/true_false_animals?zone=world_village',
              ),
            ),
          ],
          if (widget.zoneId == 'tools_professions')
            KidGameTile(
              emoji: '🔧',
              title: 'Which Tool Works?',
              subtitle: '100 levels',
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/which_tool_works?zone=tools_professions',
              ),
            ),
          ...games.map((gameType) {
            if (gameType == 'coloring' || gameType == 'free_draw') {
              return KidGameTile(
                emoji: '🖍️',
                title: 'Free Drawing',
                subtitle: 'Creative mode',
                color: theme.primary,
                onTap: () => context.push('/drawing-den'),
              );
            }
            return KidGameTile(
              emoji: _gameEmoji(gameType),
              title: GamePlayPage.titleFor(gameType),
              subtitle: _gameSubtitle(gameType),
              color: theme.primary,
              onTap: () => context.push(
                '/game/play/$gameType?zone=${widget.zoneId}',
              ),
            );
          }),
        ],
          ),
        ),
      ),
    );
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
      'jungle_grove': '🌳', 'number_mountain': '🔢', 'letter_lane': '🔤',
      'color_canyon': '🌈', 'puzzle_palace': '🧩', 'world_village': '🌍',
      'music_meadow': '🎵', 'opposites_ocean': '🔄', 'dinosaurs': '🦕',
      'space_science': '🚀', 'tools_professions': '🛠', 'sports_body': '🏅',
      'seasons_holidays': '⛄', 'household_daily': '🏠', 'drawing_den': '🎨',
    };
    return map[id] ?? '⭐';
  }

  String _gameEmoji(String type) {
    const map = {
      'animal_world': '🦁',
      'animal_names': '📝',
      'number_recognition': '1️⃣',
      'letter_recognition': '🔤', 'dino_names': '🦖',
      'space_objects': '🪐', 'shadow_game': '👤',
      'what_am_i': '❓', 'true_false': '✅',
      'which_tool_works': '🔧', 'sports_names': '⚽',
      'four_seasons': '🌸', 'household_items': '🏠',
      'fun_colors': '🎨', 'opposites': '🔄',
    };
    return map[type] ?? '🎮';
  }

  String _gameSubtitle(String type) {
    const map = {
      'animal_world': 'Quick tap — match the picture! (80 levels)',
      'animal_names': 'Read the name — picture quiz (100 levels)',
      'number_recognition': 'Find the number',
      'counting': 'Count & tap',
      'letter_recognition': 'Find the letter',
      'letter_phonics': 'Letter sounds',
      'dino_names': 'Dinosaur names',
      'space_objects': 'Space objects',
      'sports_names': 'Sports names',
      'four_seasons': 'Seasons',
      'household_items': 'Home items',
      'fun_colors': 'Fun with colors',
      'color_recognition': 'Color match',
      'opposites': 'Opposites',
    };
    return map[type] ?? 'Tap to play';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
