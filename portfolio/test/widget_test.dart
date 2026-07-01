import 'package:flutter_test/flutter_test.dart';

// Correct path linking to your root main application entry module
import 'package:sakshi_bonage_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app renders hero content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SakshiPortfolioApp());
    await tester.pump();

    expect(find.textContaining('Sakshi Rajebhau'), findsOneWidget);
    expect(find.text('DOWNLOAD RESUME'), findsOneWidget);
  });
}
