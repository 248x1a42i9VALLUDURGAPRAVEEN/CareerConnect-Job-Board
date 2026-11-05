import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/main.dart';

void main() {
  testWidgets('CareerConnect app starts', (tester) async {
    await tester.pumpWidget(const JobBoardApp());
    expect(find.text('CareerConnect'), findsOneWidget);
  });
}
