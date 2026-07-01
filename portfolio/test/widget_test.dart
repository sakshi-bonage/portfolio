import 'package:flutter_test/flutter_test.dart';

import 'package:sakshi_bonage_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app renders hero content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    expect(find.textContaining('Sakshi Rajebhau'), findsOneWidget);
    expect(find.text('DOWNLOAD RESUME'), findsOneWidget);
  });
}
