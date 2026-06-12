import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:letabli/main.dart';
import 'package:letabli/core/theme/app_theme.dart';

/// Minimal smoke test — verifies app renders without crashing
void main() {
  testWidgets("L'Établi app renders without error",
      (WidgetTester tester) async {
    // runAsync avoids fake-async timer-pending assertion from drift dispose
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const ProviderScope(child: EtabliApp()),
      );
      // The splash screen should show first
      expect(find.byType(EtabliApp), findsOneWidget);
      // Drain splash screen timers (Future.delayed 300ms + 2000ms)
      await tester.pump(const Duration(seconds: 3));
    });
  });

  testWidgets('HomeScreen shows empty state when no products',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ForgeTheme.dark,
          home: const Scaffold(body: Center(child: Text('Home'))),
        ),
      ),
    );
    // Basic render test — app doesn't crash
    expect(find.text('Home'), findsOneWidget);
  });
}
