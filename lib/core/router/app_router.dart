import 'package:go_router/go_router.dart';
import 'package:toodler_kids/presentation/features/complete_picture/complete_picture_page.dart';
import 'package:toodler_kids/presentation/features/drawing_den/drawing_den_page.dart';
import 'package:toodler_kids/presentation/features/game_play/game_play_page.dart';
import 'package:toodler_kids/presentation/features/sticker_album/sticker_album_page.dart';
import 'package:toodler_kids/presentation/features/zone/zone_detail_page.dart';
import 'package:toodler_kids/presentation/onboarding/age_selection_page.dart';
import 'package:toodler_kids/presentation/onboarding/splash_page.dart';
import 'package:toodler_kids/presentation/parent_dashboard/parent_dashboard_page.dart';
import 'package:toodler_kids/presentation/parent_dashboard/parent_gate_page.dart';
import 'package:toodler_kids/presentation/wonder_island/wonder_island_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/age-selection',
        builder: (context, state) => const AgeSelectionPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const WonderIslandPage(),
      ),
      GoRoute(
        path: '/zone/:zoneId',
        builder: (context, state) => ZoneDetailPage(
          zoneId: state.pathParameters['zoneId']!,
        ),
      ),
      GoRoute(
        path: '/game/complete-picture',
        builder: (context, state) => const CompletePicturePage(),
      ),
      GoRoute(
        path: '/game/play/:gameType',
        builder: (context, state) => GamePlayPage(
          gameType: state.pathParameters['gameType']!,
          zoneId: state.uri.queryParameters['zone'],
        ),
      ),
      GoRoute(
        path: '/drawing-den',
        builder: (context, state) => const DrawingDenPage(),
      ),
      GoRoute(
        path: '/stickers',
        builder: (context, state) => const StickerAlbumPage(),
      ),
      GoRoute(
        path: '/parent-gate',
        builder: (context, state) => const ParentGatePage(),
      ),
      GoRoute(
        path: '/parent-dashboard',
        builder: (context, state) => const ParentDashboardPage(),
      ),
    ],
  );
}
