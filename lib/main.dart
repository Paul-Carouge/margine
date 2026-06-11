import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MargineApp()));
}

/// Root widget for the Margine application.
///
/// Wraps the app with [AnimatedTheme] for smooth theme transitions and
/// uses [MaterialApp.router] with [GoRouter] for navigation.
class MargineApp extends ConsumerWidget {
  const MargineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = themeMode == ThemeMode.dark ? MargineTheme.dark : MargineTheme.light;

    return AnimatedTheme(
      data: theme,
      duration: const Duration(milliseconds: 300),
      child: MaterialApp.router(
        title: 'Margine',
        debugShowCheckedModeBanner: false,
        theme: MargineTheme.light,
        darkTheme: MargineTheme.dark,
        themeMode: themeMode,
        routerConfig: goRouter,
      ),
    );
  }
}
