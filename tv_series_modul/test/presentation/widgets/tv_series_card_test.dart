import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      routes: {
        TvSeriesDetailPage.routeName: (context) => const TvSeriesDetailPage(id: 1),
      },
    );
  }

  group('TvSeriesCard Widget Tests', () {
    testWidgets('should display image and be tappable', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Verify that CachedNetworkImage is present
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      // Verify that InkWell (tappable) is present
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should have correct image URL', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Verify the image URL
      expect(
        cachedImageWidget.imageUrl,
        'https://image.tmdb.org/t/p/w500${testTvSeries.posterPath}',
      );
    });

    testWidgets('should have placeholder widget', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Verify placeholder is not null
      expect(cachedImageWidget.placeholder, isNotNull);
    });

    testWidgets('should have error widget', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Verify errorWidget is not null
      expect(cachedImageWidget.errorWidget, isNotNull);
    });

    testWidgets('should have rounded corners (ClipRRect)', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Verify that ClipRRect is present
      expect(find.byType(ClipRRect), findsOneWidget);

      // Get the ClipRRect widget
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));

      // Verify border radius
      expect(clipRRect.borderRadius, const BorderRadius.all(Radius.circular(16)));
    });

    testWidgets('should have correct width', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Verify width
      expect(cachedImageWidget.width, 120);
    });

    testWidgets('should have Container with margin', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Find the container
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(InkWell),
              matching: find.byType(Container),
            )
            .first,
      );

      // Verify margin
      expect(container.margin, const EdgeInsets.symmetric(horizontal: 4));
    });

    // testWidgets('should navigate to detail page when tapped', (WidgetTester tester) async {
    //   // Build TvSeriesCard widget
    //   await tester.pumpWidget(
    //     makeTestableWidget(TvSeriesCard(testTvSeries)),
    //   );
    //
    //   // Find and tap the InkWell
    //   final inkWellFinder = find.byType(InkWell);
    //   expect(inkWellFinder, findsOneWidget);
    //
    //   await tester.tap(inkWellFinder);
    //   await tester.pumpAndSettle();
    //
    //   // Verify navigation occurred by checking if TvSeriesDetailPage is present
    //   expect(find.byType(TvSeriesDetailPage), findsOneWidget);
    // });

    testWidgets('should display error icon when image fails to load', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Call the errorWidget callback to cover line 31
      final errorWidget = cachedImageWidget.errorWidget!(
        tester.element(find.byType(CachedNetworkImage)),
        'test-url',
        Exception('Failed to load image'),
      );

      // Verify error widget returns an Icon
      expect(errorWidget, isA<Icon>());
      expect((errorWidget as Icon).icon, Icons.error);
    });

    testWidgets('should display CircularProgressIndicator as placeholder', (WidgetTester tester) async {
      // Build TvSeriesCard widget
      await tester.pumpWidget(
        makeTestableWidget(TvSeriesCard(testTvSeries)),
      );

      // Get the CachedNetworkImage widget
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      // Call the placeholder callback
      final placeholderWidget = cachedImageWidget.placeholder!(
        tester.element(find.byType(CachedNetworkImage)),
        'test-url',
      );

      // Verify placeholder contains CircularProgressIndicator
      expect(placeholderWidget, isA<Center>());
      // We can check if it contains CircularProgressIndicator by building it
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: placeholderWidget)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
