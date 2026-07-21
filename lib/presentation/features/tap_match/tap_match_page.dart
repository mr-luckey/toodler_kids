import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toodler_kids/core/animation/game_animations.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/game_engine/game_engines.dart';
import 'package:toodler_kids/presentation/features/tap_match/bloc/tap_match_bloc.dart';

class TapMatchPage extends StatelessWidget {
  const TapMatchPage({super.key, required this.gameType, this.zoneId});

  final String gameType;
  final String? zoneId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TapMatchBloc>()
        ..add(TapMatchLoadRequested(gameType: gameType, zoneId: zoneId)),
      child: _TapMatchView(gameType: gameType),
    );
  }
}

class _TapMatchView extends StatelessWidget {
  const _TapMatchView({required this.gameType});
  final String gameType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForGameType(gameType)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TapMatchBloc, TapMatchState>(
        builder: (context, state) {
          if (state is TapMatchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TapMatchError) {
            return Center(child: Text(state.message));
          }
          if (state is TapMatchAllDone) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('All done! Go back'),
              ),
            );
          }
          if (state is TapMatchCompleted) {
            return CelebrationOverlay(
              stars: 3,
              onDismiss: () =>
                  context.read<TapMatchBloc>().add(const TapMatchNextLevel()),
            );
          }
          if (state is TapMatchPlaying) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: TapMatchEngine(
                prompt: state.prompt,
                choices: state.choices,
                target: state.target,
                onChoice: (id, isCorrect) {
                  context.read<TapMatchBloc>().add(
                        TapMatchChoiceMade(isCorrect: isCorrect),
                      );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _titleForGameType(String type) {
    const titles = {
      'animal_world': 'Animal World',
      'number_recognition': 'Numbers',
      'letter_recognition': 'Letters',
    };
    return titles[type] ?? 'Tap Match';
  }
}
