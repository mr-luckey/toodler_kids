import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Stack(
        children: [
          const _IslandSky(),
          const _IslandHills(),
          const _FloatingDecor(),
          SafeArea(
            child: BlocBuilder<WonderIslandBloc, WonderIslandState>(
              builder: (context, state) {
                if (state is WonderIslandLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WonderIslandError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                      ),
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
        ],
      ),
    );
  }
}

class _IslandSky extends StatelessWidget {
  const _IslandSky();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5EC8F2),
            Color(0xFFA8E6CF),
            Color(0xFFFFE29A),
            Color(0xFFFFC978),
          ],
          stops: [0.0, 0.35, 0.72, 1.0],
        ),
      ),
    );
  }
}

class _IslandHills extends StatelessWidget {
  const _IslandHills();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CustomPaint(
          size: Size(
            MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height * 0.28,
          ),
          painter: _HillsPainter(),
        ),
      ),
    );
  }
}

class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final far = Paint()..color = const Color(0xFF81C784).withValues(alpha: 0.55);
    final near = Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.7);

    final farPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.05, size.width * 0.5, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(farPath, far);

    final nearPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.35, size.width * 0.45, size.height * 0.62)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width, size.height * 0.55)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(nearPath, near);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingDecor extends StatefulWidget {
  const _FloatingDecor();

  @override
  State<_FloatingDecor> createState() => _FloatingDecorState();
}

class _FloatingDecorState extends State<_FloatingDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            children: [
              Positioned(
                top: 28 + 8 * math.sin(t * math.pi),
                right: 24,
                child: const Text('☀️', style: TextStyle(fontSize: 40)),
              ),
              Positioned(
                top: 48 + 8 * math.sin(t * math.pi + 1),
                left: 16,
                child: Opacity(
                  opacity: 0.75,
                  child: const Text('☁️', style: TextStyle(fontSize: 44)),
                ),
              ),
              Positioned(
                top: 100 + 5 * math.sin(t * math.pi + 2),
                right: 56,
                child: Opacity(
                  opacity: 0.65,
                  child: const Text('☁️', style: TextStyle(fontSize: 32)),
                ),
              ),
            ],
          );
        },
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
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF29B6F6), width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0288D1).withValues(alpha: 0.35),
                  offset: const Offset(0, 6),
                  blurRadius: 0,
                ),
              ],
            ),
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
                        style: GoogleFonts.fredoka(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.w700,
                          fontSize: Responsive.scale(context, 20, 26),
                        ),
                      ),
                      Text(
                        'Wonder Island 🏝️',
                        style: GoogleFonts.baloo2(
                          color: const Color(0xFF00897B),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                KidStarBadge(stars: state.totalStars),
                const SizedBox(width: 4),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE3F2FD),
                    side: const BorderSide(color: Color(0xFF29B6F6), width: 2),
                  ),
                  icon: const Icon(Icons.settings_rounded, color: Color(0xFF1565C0)),
                  onPressed: () => context.push('/parent-gate'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: pad, vertical: 6),
          child: const LumiWidget(
            emotion: LumiEmotion.happy,
            message: 'Pick a fun zone — let’s play! 🎉',
            size: 44,
            compact: true,
          ),
        ),
        Expanded(
          child: Responsive.centeredContent(
            context,
            GridView.builder(
              padding: EdgeInsets.fromLTRB(pad, 0, pad, 12),
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                // Slightly taller cards so title + subtitle never overflow.
                childAspectRatio: cols >= 4 ? 1.05 : (cols == 3 ? 1.0 : 0.92),
              ),
              itemCount: state.zones.length,
              itemBuilder: (context, index) {
                final zone = state.zones[index];
                return _ZoneGridTile(zone: zone, totalStars: state.totalStars);
              },
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, 0, pad, 8),
            child: Row(
              children: [
                Expanded(
                  child: KidQuickPill(
                    emoji: '🏆',
                    label: 'Stickers',
                    color: const Color(0xFFFFB300),
                    onTap: () => context.push('/stickers'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KidQuickPill(
                    emoji: '🎨',
                    label: 'Drawing',
                    color: const Color(0xFF42A5F5),
                    onTap: () => context.push('/drawing-den'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KidQuickPill(
                    emoji: '🧩',
                    label: 'Puzzles',
                    color: const Color(0xFF7E57C2),
                    onTap: () => context.push(
                      '/game/play/complete_picture?zone=puzzle_palace',
                    ),
                  ),
                ),
              ],
            ),
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

    return KidZoneCard(
      emoji: _zoneEmoji(zone.id),
      title: _zoneName(zone.id),
      primary: theme.hubGradient.first,
      accent: theme.hubGradient.last,
      locked: false,
      subtitle: '${zone.levelCount}+ levels',
      zoneId: zone.id,
      showLottieSticker: false,
      onTap: () {
        if (zone.id == 'drawing_den') {
          context.push('/drawing-den');
        } else {
          context.push('/zone/${zone.id}');
        }
      },
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
