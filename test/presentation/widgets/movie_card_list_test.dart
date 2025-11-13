import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Movie Detail Page')),
            ),
          );
        }
        return null;
      },
    );
  }

  group('MovieCard Widget Tests', () {
    final testMovie = Movie(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'This is a test movie overview that should be displayed in the card',
      popularity: 100.0,
      posterPath: '/poster.jpg',
      releaseDate: '2024-01-01',
      title: 'Test Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 1000,
    );

    testWidgets('should display movie title', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert
      expect(find.text('Test Movie Title'), findsOneWidget);
    });

    testWidgets('should display movie overview', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert
      expect(
        find.text('This is a test movie overview that should be displayed in the card'),
        findsOneWidget,
      );
    });

    testWidgets('should display dash when title is null', (WidgetTester tester) async {
      // arrange
      final movieWithNullTitle = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'Original Title',
        overview: 'Overview',
        popularity: 100.0,
        posterPath: '/poster.jpg',
        releaseDate: '2024-01-01',
        title: null,
        video: false,
        voteAverage: 8.5,
        voteCount: 1000,
      );

      await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithNullTitle)));

      // assert
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('should display dash when overview is null', (WidgetTester tester) async {
      // arrange
      final movieWithNullOverview = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'Original Title',
        overview: null,
        popularity: 100.0,
        posterPath: '/poster.jpg',
        releaseDate: '2024-01-01',
        title: 'Test Title',
        video: false,
        voteAverage: 8.5,
        voteCount: 1000,
      );

      await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithNullOverview)));

      // assert
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('should have correct image URL', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);

      // assert
      expect(cachedNetworkImageFinder, findsOneWidget);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);
      expect(cachedNetworkImage.imageUrl, '$BASE_IMAGE_URL${testMovie.posterPath}');
    });

    testWidgets('should display CircularProgressIndicator as placeholder', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

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
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

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

    testWidgets('should have InkWell widget', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should navigate to MovieDetailPage when tapped', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Movie Detail Page'), findsOneWidget);
    });

    testWidgets('should pass correct movie id when navigating', (WidgetTester tester) async {
      // arrange
      int? capturedMovieId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(testMovie),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == MovieDetailPage.ROUTE_NAME) {
              capturedMovieId = settings.arguments as int?;
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(child: Text('Movie Detail')),
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
      expect(capturedMovieId, testMovie.id);
    });

    testWidgets('should have Card widget', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should have ClipRRect for rounded corners', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should apply kHeading6 style to title', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final titleFinder = find.text('Test Movie Title');
      final titleWidget = tester.widget<Text>(titleFinder);

      // assert
      expect(titleWidget.style, kHeading6);
    });

    testWidgets('should have maxLines 1 for title', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final titleFinder = find.text('Test Movie Title');
      final titleWidget = tester.widget<Text>(titleFinder);

      // assert
      expect(titleWidget.maxLines, 1);
      expect(titleWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have maxLines 2 for overview', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final overviewFinder = find.text('This is a test movie overview that should be displayed in the card');
      final overviewWidget = tester.widget<Text>(overviewFinder);

      // assert
      expect(overviewWidget.maxLines, 2);
      expect(overviewWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have Stack widget with bottomLeft alignment', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final stackFinder = find.descendant(
        of: find.byType(MovieCard),
        matching: find.byType(Stack),
      );
      final stack = tester.widget<Stack>(stackFinder);

      // assert
      expect(stack.alignment, Alignment.bottomLeft);
    });

    testWidgets('should display image with width 80', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // act
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImage = tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // assert
      expect(cachedNetworkImage.width, 80);
    });

    testWidgets('should handle very long title with ellipsis', (WidgetTester tester) async {
      // arrange
      final movieWithLongTitle = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'Original Title',
        overview: 'Overview',
        popularity: 100.0,
        posterPath: '/poster.jpg',
        releaseDate: '2024-01-01',
        title: 'This is a very long movie title that should be truncated with ellipsis',
        video: false,
        voteAverage: 8.5,
        voteCount: 1000,
      );

      await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithLongTitle)));

      // act
      final titleFinder = find.text('This is a very long movie title that should be truncated with ellipsis');
      final titleWidget = tester.widget<Text>(titleFinder);

      // assert
      expect(titleWidget.maxLines, 1);
      expect(titleWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should handle very long overview with ellipsis', (WidgetTester tester) async {
      // arrange
      final movieWithLongOverview = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'Original Title',
        overview:
            'This is a very long overview text that should be truncated with ellipsis after two lines. It contains a lot of information about the movie plot and characters.',
        popularity: 100.0,
        posterPath: '/poster.jpg',
        releaseDate: '2024-01-01',
        title: 'Test Title',
        video: false,
        voteAverage: 8.5,
        voteCount: 1000,
      );

      await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithLongOverview)));

      // act
      final overviewFinder = find.text(
          'This is a very long overview text that should be truncated with ellipsis after two lines. It contains a lot of information about the movie plot and characters.');
      final overviewWidget = tester.widget<Text>(overviewFinder);

      // assert
      expect(overviewWidget.maxLines, 2);
      expect(overviewWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should render properly with all components', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert - verify all key components exist
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets); // Multiple SizedBox widgets expected
    });

    testWidgets('should have proper widget hierarchy', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

      // assert - verify InkWell is ancestor of Card
      expect(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Card),
        ),
        findsOneWidget,
      );

      // assert - verify Stack contains Card
      expect(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(Card),
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
  });
}
