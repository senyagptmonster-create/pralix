import 'package:flutter_test/flutter_test.dart';
import 'package:pralix/pralix_app.dart';

void main() {
  testWidgets('PralixApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PralixApp());
    expect(find.text('Pralix Blueprint Scale'), findsOneWidget);
  });
}
