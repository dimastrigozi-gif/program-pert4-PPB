import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_pertemuan4/modul_04_app.dart';

void main() {
  testWidgets('Aplikasi Portal Pengumuman bisa dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const Modul04App());
    expect(find.text('Portal Pengumuman'), findsOneWidget);
  });
}