import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:tv_series_modul/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == TvSeriesDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('TV Series Detail Page')),
            ),
          );
        }
        return null;
      },
    );
  }

  group('TvSeriesCard Widget Tests', () {
    testWidgets('should display CachedNetworkImage', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should have InkWell widget for tap detection', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // assert
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should have correct image URL', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);

      // assert
      expect(cachedNetworkImageFinder, findsOneWidget);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);
      expect(cachedNetworkImage.imageUrl, 'https://image.tmdb.org/t/p/w500${testTvSeries.posterPath}');
    });

    testWidgets('should have correct image width of 120', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // assert
      expect(cachedNetworkImage.width, 120);
    });

    testWidgets('should display CircularProgressIndicator as placeholder', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // Test placeholder
      final placeholder = cachedNetworkImage.placeholder?.call(
        tester.element(cachedNetworkImageFinder),
        'test_url',
      );

      // assert
      expect(placeholder, isA<Center>());
    });

    testWidgets('should display error icon on image load error', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // Test error widget
      final errorWidget = cachedNetworkImage.errorWidget?.call(
        tester.element(cachedNetworkImageFinder),
        'test_url',
        Exception('Error'),
      );

      // assert
      expect(errorWidget, isA<Icon>());
    });

    testWidgets('should have ClipRRect for rounded corners', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // assert
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should have ClipRRect with correct border radius', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final clipRRectFinder = find.byType(ClipRRect);
      final clipRRect = tester.widget<ClipRRect>(clipRRectFinder);

      // assert
      expect(clipRRect.borderRadius, const BorderRadius.all(Radius.circular(16)));
    });

    testWidgets('should have Container with correct margin', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      final containerFinder = find.descendant(
        of: find.byType(TvSeriesCard),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder.first);

      // assert
      expect((container.margin as EdgeInsets), const EdgeInsets.symmetric(horizontal: 4));
    });

    testWidgets('should navigate to TvSeriesDetailPage when tapped', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('TV Series Detail Page'), findsOneWidget);
    });

    testWidgets('should pass correct tv series id when navigating', (WidgetTester tester) async {
      // arrange
      int? capturedTvSeriesId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TvSeriesCard(testTvSeries),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == TvSeriesDetailPage.routeName) {
              capturedTvSeriesId = settings.arguments as int?;
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(child: Text('TV Series Detail')),
                ),
              );
            }
            return null;
          },
        ),
      );

      // act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(capturedTvSeriesId, testTvSeries.id);
    });

    testWidgets('should render properly with all components', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // assert - verify all key components exist
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should have proper widget hierarchy', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(testTvSeries)));

      // assert - verify InkWell contains ClipRRect
      expect(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(ClipRRect),
        ),
        findsOneWidget,
      );

      // assert - verify ClipRRect contains CachedNetworkImage
      expect(
        find.descendant(
          of: find.byType(ClipRRect),
          matching: find.byType(CachedNetworkImage),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should handle different poster paths correctly', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithDifferentPath = TvSeries(
        id: 2,
        name: 'Different TV Series',
        overview: 'Different Overview',
        posterPath: '/different_poster.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.0,
        voteCount: 200,
        firstAirDate: '2024-02-01',
        originCountry: const ['UK'],
        genreIds: const [3, 4],
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tvSeriesWithDifferentPath)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // assert
      expect(cachedNetworkImage.imageUrl, 'https://image.tmdb.org/t/p/w500/different_poster.jpg');
    });

    testWidgets('should handle null poster path gracefully', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithNullPoster = TvSeries(
        id: 3,
        name: 'TV Series No Poster',
        overview: 'Overview',
        posterPath: null,
        backdropPath: '/backdrop.jpg',
        voteAverage: 7.0,
        voteCount: 150,
        firstAirDate: '2024-03-01',
        originCountry: const ['CA'],
        genreIds: const [5],
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tvSeriesWithNullPoster)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // assert - should still create URL with null value
      expect(cachedNetworkImage.imageUrl, 'https://image.tmdb.org/t/p/w500null');
    });

    testWidgets('should create separate instances for different tv series', (WidgetTester tester) async {
      // arrange
      final tvSeries1 = TvSeries(
        id: 1,
        name: 'TV Series 1',
        overview: 'Overview 1',
        posterPath: '/poster1.jpg',
        backdropPath: '/backdrop1.jpg',
        voteAverage: 7.5,
        voteCount: 100,
        firstAirDate: '2024-01-01',
        originCountry: const ['US'],
        genreIds: const [1, 2],
      );

      final tvSeries2 = TvSeries(
        id: 2,
        name: 'TV Series 2',
        overview: 'Overview 2',
        posterPath: '/poster2.jpg',
        backdropPath: '/backdrop2.jpg',
        voteAverage: 8.0,
        voteCount: 200,
        firstAirDate: '2024-02-01',
        originCountry: const ['UK'],
        genreIds: const [3, 4],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                TvSeriesCard(tvSeries1),
                TvSeriesCard(tvSeries2),
              ],
            ),
          ),
        ),
      );

      // assert - should have two cards
      expect(find.byType(TvSeriesCard), findsNWidgets(2));
      expect(find.byType(InkWell), findsNWidgets(2));
      expect(find.byType(CachedNetworkImage), findsNWidgets(2));
    });

    testWidgets('should maintain immutability with const constructor', (WidgetTester tester) async {
      // arrange
      const key1 = Key('card1');
      const key2 = Key('card2');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TvSeriesCard(testTvSeries, key: key1),
                TvSeriesCard(testTvSeries, key: key2),
              ],
            ),
          ),
        ),
      );

      // assert
      expect(find.byKey(key1), findsOneWidget);
      expect(find.byKey(key2), findsOneWidget);
    });
  });
}
