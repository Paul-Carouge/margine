import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MargineApp()));
}

/// Root widget for the Margine application.
class MargineApp extends ConsumerWidget {
  const MargineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Margine',
      debugShowCheckedModeBanner: false,
      theme: MargineTheme.light,
      darkTheme: MargineTheme.dark,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
