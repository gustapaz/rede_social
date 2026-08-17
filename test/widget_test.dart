import 'package:flutter_test/flutter_test.dart';
import 'package:rede_social/main.dart';

void main() {
  testWidgets('App inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    await tester.pump();
  });
}
