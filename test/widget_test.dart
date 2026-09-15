import 'package:flutter_test/flutter_test.dart';
import 'package:pralix/presentation/pralix_app.dart';

void main() {
  testWidgets('PralixApp launches successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PralixApp());
    expect(find.byType(PralixApp), findsOneWidget);
  });
}