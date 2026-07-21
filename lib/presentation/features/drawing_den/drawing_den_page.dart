import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toodler_kids/core/constants/app_constants.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/drawing/coloring_svg_canvas.dart';
import 'package:toodler_kids/core/drawing/drawing_engine.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/core/theme/zone_theme.dart';
import 'package:toodler_kids/presentation/features/drawing_den/bloc/drawing_den_bloc.dart';
import 'package:toodler_kids/presentation/lumi/lumi_widget.dart';
import 'package:toodler_kids/presentation/widgets/cartoon_game_widgets.dart';

class DrawingDenPage extends StatelessWidget {
  const DrawingDenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DrawingDenBloc>()..add(const DrawingDenLoadRequested()),
      child: const _DrawingDenView(),
    );
  }
}

class _DrawingDenView extends StatelessWidget {
  const _DrawingDenView();

  static const _theme = ZoneVisualTheme(
    id: 'drawing_den',
    primary: Color(0xFF42A5F5),
    accent: Color(0xFFFF7043),
    background: Color(0xFFE3F2FD),
    hubGradient: [Color(0xFF64B5F6), Color(0xFF1565C0)],
    screenGradient: [Color(0xFFBBDEFB), Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
    decorations: [ZoneDecoration.paint],
    cardBorderColor: Color(0xFF1565C0),
  );

  @override
  Widget build(BuildContext context) {
    return ZoneGameScaffold(
      zoneId: 'drawing_den',
      title: 'Drawing Den 🎨',
      onBack: () => context.pop(),
      body: BlocBuilder<DrawingDenBloc, DrawingDenState>(
        builder: (context, state) {
          if (state is DrawingDenLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! DrawingDenLoaded) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Responsive.pad(context),
                  4,
                  Responsive.pad(context),
                  0,
                ),
                child: LumiWidget(
                  emotion: LumiEmotion.excited,
                  message: state.mode == DrawingMode.colorFill
                      ? 'Pick a picture and tap to color!'
                      : 'Draw anything you like!',
                  size: 44,
                  compact: true,
                ),
              ),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pad(context),
                    vertical: 8,
                  ),
                  children: state.templates.map((t) {
                    final selected = state.selectedTemplate?.id == t.id;
                    final name = t.displayName ?? _templateLabel(t.id);
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CartoonTemplateThumb(
                        label: name.split(' ').first,
                        selected: selected,
                        accent: _theme.primary,
                        thumbnail: SvgPicture.asset(
                          t.svgPath,
                          fit: BoxFit.contain,
                        ),
                        onTap: () => context.read<DrawingDenBloc>().add(
                              DrawingDenTemplateSelected(t),
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartoonPillToggle(
                      label: '🎨 Color',
                      selected: state.mode == DrawingMode.colorFill,
                      accent: _theme.primary,
                      onTap: () => context.read<DrawingDenBloc>().add(
                            const DrawingDenModeChanged(DrawingMode.colorFill),
                          ),
                    ),
                    const SizedBox(width: 12),
                    CartoonPillToggle(
                      label: '✏️ Draw',
                      selected: state.mode == DrawingMode.freeDraw,
                      accent: _theme.accent,
                      onTap: () => context.read<DrawingDenBloc>().add(
                            const DrawingDenModeChanged(DrawingMode.freeDraw),
                          ),
                    ),
                    const SizedBox(width: 12),
                    _ToolButton(
                      icon: Icons.undo_rounded,
                      color: _theme.primary,
                      onTap: () =>
                          context.read<DrawingDenBloc>().add(const DrawingDenUndo()),
                    ),
                    _ToolButton(
                      icon: Icons.save_rounded,
                      color: _theme.accent,
                      onTap: () =>
                          context.read<DrawingDenBloc>().add(const DrawingDenSave()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Responsive.pad(context)),
                  child: CartoonCanvasFrame(
                    accent: _theme.primary,
                    child: state.mode == DrawingMode.colorFill
                        ? state.selectedTemplate == null
                            ? Center(
                                child: Text(
                                  'Pick a picture above! 👆',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    color: _theme.primary,
                                  ),
                                ),
                              )
                            : ColoringSvgCanvas(
                                svgAssetPath: state.selectedTemplate!.svgPath,
                                regions: state.fillRegions,
                                regionColors: state.regionColors,
                                selectedColor: state.selectedColor,
                                onRegionFilled: (id, color) {
                                  context.read<DrawingDenBloc>().add(
                                        DrawingDenRegionFilled(
                                          regionId: id,
                                          color: color,
                                        ),
                                      );
                                },
                              )
                        : FreeDrawCanvas(
                            color: state.selectedColor,
                            strokeWidth: state.strokeWidth,
                            strokes: state.strokes,
                            onStrokeComplete: (stroke) {
                              context.read<DrawingDenBloc>().add(
                                    DrawingDenStrokeAdded(stroke),
                                  );
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.pad(context),
                    vertical: 8,
                  ),
                  children: KidColorPalette.colors.map((color) {
                    return CartoonColorSwatch(
                      color: color,
                      selected: state.selectedColor == color,
                      onTap: () => context.read<DrawingDenBloc>().add(
                            DrawingDenColorSelected(color),
                          ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _templateLabel(String id) {
    return id.replaceAll('_', ' ').split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              offset: const Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
