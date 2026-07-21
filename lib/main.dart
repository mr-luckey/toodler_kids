import 'package:flutter/material.dart';
import 'package:toodler_kids/core/di/injection.dart';
import 'package:toodler_kids/core/router/app_router.dart';
import 'package:toodler_kids/core/theme/app_theme.dart';
import 'package:toodler_kids/core/theme/responsive.dart';
import 'package:toodler_kids/data/datasources/local_progress_datasource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localDs = LocalProgressDataSource();
  await localDs.init();
  await configureDependencies();
  runApp(const KidsLearnPlayApp());
}

class KidsLearnPlayApp extends StatelessWidget {
  const KidsLearnPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KidsLearnPlay',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => KidTextScaler(child: child ?? const SizedBox.shrink()),
    );
  }
}
