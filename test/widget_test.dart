import 'package:flutter_test/flutter_test.dart';
import 'package:simple_stock/core/di/injection_container.dart' as di;
import 'package:simple_stock/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await di.init();
    await tester.pumpWidget(const SimpleStockApp());

    expect(find.text('License Login Page'), findsOneWidget);
  });
}
