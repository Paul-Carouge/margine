import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: EtabliApp()));
}

/// Root widget for L'Établi v3.0.0 — Forge.
class EtabliApp extends ConsumerWidget {
  const EtabliApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: "L'Établi",
      debugShowCheckedModeBanner: false,
      theme: ForgeTheme.light,
      darkTheme: ForgeTheme.dark,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
