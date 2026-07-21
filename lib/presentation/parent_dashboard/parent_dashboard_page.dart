import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/presentation/parent_dashboard/bloc/parent_dashboard_bloc.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ParentDashboardBloc>()..add(const ParentDashboardLoadRequested()),
      child: const _ParentDashboardView(),
    );
  }
}

class _ParentDashboardView extends StatelessWidget {
  const _ParentDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportReport(context),
          ),
        ],
      ),
      body: BlocBuilder<ParentDashboardBloc, ParentDashboardState>(
        builder: (context, state) {
          if (state is ParentDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! ParentDashboardLoaded) return const SizedBox.shrink();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: 'Child Profile',
                value: state.profile?.name ?? 'Explorer',
                subtitle: 'Age tier: ${state.profile?.ageTierId ?? "N/A"}',
                icon: Icons.child_care,
              ),
              _StatCard(
                title: 'Stars Earned',
                value: '${state.totalStars}',
                subtitle: 'Keep playing to unlock more zones!',
                icon: Icons.star,
                color: const Color(0xFFFFB74D),
              ),
              _StatCard(
                title: 'Levels Completed',
                value: '${state.levelsCompleted}',
                subtitle: '~${state.totalTimeMinutes} min estimated play time',
                icon: Icons.check_circle,
                color: const Color(0xFF66BB6A),
              ),
              _StatCard(
                title: 'Badges',
                value: '${state.earnedBadges.length}',
                subtitle: state.earnedBadges.isEmpty
                    ? 'Complete activities to earn badges'
                    : state.earnedBadges.join(', '),
                icon: Icons.emoji_events,
                color: const Color(0xFFAB47BC),
              ),
              const SizedBox(height: 16),
              Text(
                'Learning Map',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (state.learningMap.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Play 5+ sessions to see strengths and areas to grow.',
                    ),
                  ),
                )
              else
                ...state.learningMap.take(6).map((entry) => ListTile(
                      leading: Icon(
                        entry.isStrength ? Icons.trending_up : Icons.trending_down,
                        color: entry.isStrength ? Colors.green : Colors.orange,
                      ),
                      title: Text(entry.concept),
                      trailing: Text('${(entry.score * 100).toInt()}%'),
                    )),
              if (state.recommendedConcepts.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Recommended Focus',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...state.recommendedConcepts.map(
                  (c) => ListTile(
                    leading: const Icon(Icons.lightbulb, color: Colors.amber),
                    title: Text(c),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _exportReport(BuildContext context) async {
    final bloc = context.read<ParentDashboardBloc>();
    final state = bloc.state;
    if (state is! ParentDashboardLoaded) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('KidsLearnPlay Weekly Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Child: ${state.profile?.name ?? "Explorer"}'),
            pw.Text('Stars Earned: ${state.totalStars}'),
            pw.Text('Levels Completed: ${state.levelsCompleted}'),
            pw.Text('Badges: ${state.earnedBadges.length}'),
            pw.SizedBox(height: 16),
            pw.Text('Learning Map:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ...state.learningMap.take(10).map(
                  (e) => pw.Text(
                    '${e.concept}: ${(e.score * 100).toInt()}% ${e.isStrength ? "(Strength)" : "(Grow)"}',
                  ),
                ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/kidslearnplay_report.pdf');
    await file.writeAsBytes(await pdf.save());
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'KidsLearnPlay Progress Report'),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (color ?? const Color(0xFF6C63FF)).withValues(alpha: 0.2),
          child: Icon(icon, color: color ?? const Color(0xFF6C63FF)),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF6C63FF),
          ),
        ),
      ),
    );
  }
}
