import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'core/services/update_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/forge_colors.dart';
import 'presentation/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger la couleur d'accent sauvegardée
  final prefs = await SharedPreferences.getInstance();
  final savedColorValue = prefs.getInt('accent_color');
  final initialAccentColor = savedColorValue != null
      ? Color(savedColorValue)
      : ForgeColors.crimson;

  // Charger la version ignorée
  final dismissedVersion = await UpdateService.getDismissedVersion();

  initializeDateFormatting('fr_FR', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      overrides: [
        accentColorProvider.overrideWith((ref) => initialAccentColor),
        dismissedVersionProvider.overrideWith((ref) => dismissedVersion),
      ],
      child: const EtabliApp(),
    ),
  );
}

/// Root widget for L'Établi v3.2.0 — Forge.
class EtabliApp extends ConsumerWidget {
  const EtabliApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);

    // Sauvegarder automatiquement la couleur d'accent
    ref.listen<Color>(accentColorProvider, (prev, next) {
      SharedPreferences.getInstance().then(
        (prefs) => prefs.setInt('accent_color', next.toARGB32()),
      );
    });

    // Sauvegarder automatiquement la version ignorée
    ref.listen<String?>(dismissedVersionProvider, (prev, next) {
      final prefs = SharedPreferences.getInstance();
      if (next != null) {
        prefs.then((p) => p.setString('dismissed_version', next));
      } else {
        prefs.then((p) => p.remove('dismissed_version'));
      }
    });

    return MaterialApp.router(
      title: "L'Établi",
      debugShowCheckedModeBanner: false,
      theme: ForgeTheme.light(accentColor),
      darkTheme: ForgeTheme.dark(accentColor),
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
