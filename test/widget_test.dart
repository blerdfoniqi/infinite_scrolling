import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scrolling/main.dart';

void main() {
  testWidgets('renders the Infinite Scrolling list screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Infinite Scrolling'), findsOneWidget);
  });
}
