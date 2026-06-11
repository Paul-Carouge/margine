// flutter test --no-test-assets to skip web/screenshot assets.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:letabli/main.dart';

void main() {
  testWidgets('L\'Établi app renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MargineApp()));
    expect(find.byType(MargineApp), findsOneWidget);
  });
}
