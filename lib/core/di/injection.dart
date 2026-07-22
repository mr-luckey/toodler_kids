import 'package:get_it/get_it.dart';
import 'package:toodler_kids/core/adaptive/adaptive_engine.dart';
import 'package:toodler_kids/core/audio/sound_manager.dart';
import 'package:toodler_kids/data/datasources/json_content_datasource.dart';
import 'package:toodler_kids/data/datasources/local_progress_datasource.dart';
import 'package:toodler_kids/data/repositories/content_repository_impl.dart';
import 'package:toodler_kids/data/repositories/progress_repository_impl.dart';
import 'package:toodler_kids/domain/repositories/content_repository.dart';
import 'package:toodler_kids/domain/repositories/progress_repository.dart';
import 'package:toodler_kids/domain/usecases/content_usecases.dart';
import 'package:toodler_kids/domain/usecases/progress_usecases.dart';
import 'package:toodler_kids/presentation/features/complete_picture/bloc/complete_picture_bloc.dart';
import 'package:toodler_kids/presentation/features/drawing_den/bloc/drawing_den_bloc.dart';
import 'package:toodler_kids/presentation/features/game_play/bloc/game_play_bloc.dart';
import 'package:toodler_kids/presentation/features/tap_match/bloc/tap_match_bloc.dart';
import 'package:toodler_kids/presentation/parent_dashboard/bloc/parent_dashboard_bloc.dart';
import 'package:toodler_kids/presentation/wonder_island/bloc/wonder_island_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<SoundManager>(() => SoundManager());
  getIt.registerLazySingleton<LocalProgressDataSource>(
    () => LocalProgressDataSource(),
  );
  getIt.registerLazySingleton<AdaptiveEngine>(
    () => AdaptiveEngine(dataSource: getIt<LocalProgressDataSource>()),
  );

  getIt.registerLazySingleton<JsonContentDataSource>(
    () => JsonContentDataSource(),
  );

  getIt.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => LoadManifest(getIt()));
  getIt.registerLazySingleton(() => GetZones(getIt()));
  getIt.registerLazySingleton(() => GetLevelsForGame(getIt()));
  getIt.registerLazySingleton(() => GetDrawingTemplates(getIt()));
  getIt.registerLazySingleton(() => GetFunFacts(getIt()));
  getIt.registerLazySingleton(() => SaveLevelProgress(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetChildProfile(getIt()));
  getIt.registerLazySingleton(() => SaveChildProfile(getIt()));

  getIt.registerFactory(
    () => WonderIslandBloc(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => CompletePictureBloc(getIt(), getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => GamePlayBloc(getIt(), getIt(), getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => TapMatchBloc(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => DrawingDenBloc(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => ParentDashboardBloc(getIt(), getIt()),
  );

  await getIt<AdaptiveEngine>().init();
}
