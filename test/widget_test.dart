// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sairam_linkup/main.dart';
import 'package:sairam_linkup/providers/app_provider.dart';

void main() {
  testWidgets('Sairam LinkUp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DemoProvider()),
          ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
          ChangeNotifierProvider(create: (_) => EventProvider()),
          ChangeNotifierProvider(create: (_) => OpportunityProvider()),
          ChangeNotifierProvider(create: (_) => PeopleProvider()),
        ],
        child: const SairamLinkUpApp(),
      ),
    );

    expect(find.byType(SairamLinkUpApp), findsOneWidget);
  });
}
