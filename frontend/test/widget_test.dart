import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: KrishiOSApp()));
    expect(find.text('KrishiOS'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
