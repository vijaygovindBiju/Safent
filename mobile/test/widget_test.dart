import 'package:flutter_test/flutter_test.dart';
import 'package:travel_sos_mesh/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelSosMeshApp());
    expect(find.byType(TravelSosMeshApp), findsOneWidget);
  });
}
