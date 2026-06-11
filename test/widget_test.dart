import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:margine/main.dart';

void main() {
  testWidgets('Margine app renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MargineApp()));
    // Verify the app builds without throwing.
    expect(find.byType(MargineApp), findsOneWidget);
  });
}
