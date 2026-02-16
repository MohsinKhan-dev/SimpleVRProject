import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sample_flutter_application/app.dart';

void main() {
  testWidgets('App renders connection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('Connect to Server'), findsOneWidget);
  });
}
