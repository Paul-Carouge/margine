import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: _MargineAppLoader()));
}

/// Initializes GoogleFonts and then launches the app.
class _MargineAppLoader extends StatelessWidget {
  const _MargineAppLoader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GoogleFonts.pendingFonts([GoogleFonts.sora(), GoogleFonts.inter()]),
      builder: (context, snapshot) {
        return const MargineApp();
      },
    );
  }
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
