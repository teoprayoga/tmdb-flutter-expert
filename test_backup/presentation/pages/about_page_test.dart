import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display about content', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final textFinder = find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.');

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should have back button', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final backButtonFinder = find.byIcon(Icons.arrow_back);

    expect(backButtonFinder, findsOneWidget);
  });

  testWidgets('Page should display logo image', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final imageFinder = find.byType(Image);

    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Back button should be tappable', (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
  });
}
