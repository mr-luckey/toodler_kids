import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/presentation/lumi/lumi_widget.dart';
import 'package:toodler_kids/presentation/widgets/kid_ui.dart';
import 'package:toodler_kids/presentation/wonder_island/bloc/wonder_island_bloc.dart';

class WonderIslandPage extends StatelessWidget {
  const WonderIslandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WonderIslandBloc>()..add(const WonderIslandLoadRequested()),
      child: const _WonderIslandView(),
    );
  }
}

class _WonderIslandView extends StatelessWidget {
  const _WonderIslandView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFB8E6B8), Color(0xFF98D8AA)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<WonderIslandBloc, WonderIslandState>(
            builder: (context, state) {
              if (state is WonderIslandLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is WonderIslandError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Error: ${state.message}', textAlign: TextAlign.center),
                  ),
                );
              }
              if (state is WonderIslandLoaded) {
                return _MapContent(state: state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _MapContent extends StatelessWidget {
  const _MapContent({required this.state});

  final WonderIslandLoaded state;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.gridColumns(context);
    final pad = Responsive.pad(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(pad, 8, pad, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                    ),
                    Text(
                      'Wonder Island',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              KidStarBadge(stars: state.totalStars),
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () => context.push('/parent-gate'),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: pad, vertical: 8),
          child: LumiWidget(
            emotion: LumiEmotion.happy,
            message: 'Tap a zone to start learning!',
            size: 48,
            compact: true,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(pad, 0, pad, 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 3 ? 1.05 : 0.95,
            ),
            itemCount: state.zones.length,
            itemBuilder: (context, index) {
              final zone = state.zones[index];
              return _ZoneGridTile(zone: zone, totalStars: state.totalStars);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
          child: Row(
            children: [
              KidQuickPill(
                emoji: '🏆',
                label: 'Stickers',
                onTap: () => context.push('/stickers'),
              ),
              const SizedBox(width: 10),
              KidQuickPill(
                emoji: '🎨',
                label: 'Drawing',
                onTap: () => context.push('/drawing-den'),
              ),
              const SizedBox(width: 10),
              KidQuickPill(
                emoji: '🧩',
                label: 'Puzzles',
                onTap: () => context.push(
                  '/game/play/complete_picture?zone=puzzle_palace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoneGridTile extends StatelessWidget {
  const _ZoneGridTile({required this.zone, required this.totalStars});

  final ZoneEntity zone;
  final int totalStars;

  @override
  Widget build(BuildContext context) {
    final theme = ZoneVisualTheme.forZone(zone.id);
    final locked = !zone.isFree && totalStars < zone.unlockStars;

    return KidZoneCard(
      emoji: _zoneEmoji(zone.id),
      title: _zoneName(zone.id),
      primary: theme.hubGradient.first,
      accent: theme.hubGradient.last,
      locked: locked,
      subtitle: locked ? '${zone.unlockStars} ⭐' : '${zone.levelCount}+ levels',
      onTap: locked ? null : () => context.push('/zone/${zone.id}'),
    );
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

  String _zoneName(String id) {
    const map = {
      'jungle_grove': 'Jungle Grove',
      'number_mountain': 'Number Mountain',
      'letter_lane': 'Letter Lane',
      'color_canyon': 'Color Canyon',
      'puzzle_palace': 'Puzzle Palace',
      'world_village': 'World Village',
      'music_meadow': 'Music Meadow',
      'opposites_ocean': 'Opposites Ocean',
      'dinosaurs': 'Dino Zone',
      'space_science': 'Space Zone',
      'tools_professions': 'Tools Zone',
      'sports_body': 'Sports Zone',
      'seasons_holidays': 'Seasons Zone',
      'household_daily': 'Household',
      'drawing_den': 'Drawing Den',
    };
    return map[id] ?? id;
  }
}
