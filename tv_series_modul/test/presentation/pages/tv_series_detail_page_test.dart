import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series_modul/domain/entities/tv_series.dart';
import 'package:tv_series_modul/domain/entities/tv_series_detail.dart';
import 'package:tv_series_modul/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series_modul/presentation/pages/tv_series/tv_series_detail_page.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class FakeTvSeriesDetailEvent extends Fake implements TvSeriesDetailEvent {}

class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesDetailEvent());
    registerFallbackValue(FakeTvSeriesDetailState());
  });

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  const tTvSeriesDetail = TvSeriesDetail(
    id: 1,
    name: 'Breaking Bad',
    overview: 'A high school chemistry teacher',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 9.5,
    voteCount: 10000,
    firstAirDate: '2008-01-20',
    lastAirDate: '2013-09-29',
    genres: [Genre(id: 1, name: 'Drama')],
    numberOfSeasons: 5,
    numberOfEpisodes: 62,
    seasons: [
      Season(
        id: 1,
        name: 'Season 1',
        seasonNumber: 1,
        episodeCount: 7,
        posterPath: '/season1.jpg',
        airDate: '2008-01-20',
        overview: 'First season',
      ),
    ],
    status: 'Ended',
    type: 'Scripted',
    inProduction: false,
    originCountry: ['US'],
  );

  const tTvSeries = TvSeries(
    id: 2,
    name: 'Game of Thrones',
    overview: 'Epic fantasy',
    posterPath: '/poster2.jpg',
    backdropPath: '/backdrop2.jpg',
    voteAverage: 8.5,
    voteCount: 5000,
    firstAirDate: '2011-04-17',
    originCountry: ['US'],
    genreIds: [18, 10765],
  );

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TvSeriesDetailPage', () {
    testWidgets('should display loading indicator when state is loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(isLoading: true),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when state has error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(message: 'Error message'),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should display detail content when data is loaded',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Breaking Bad'), findsOneWidget);
      expect(find.text('A high school chemistry teacher'), findsOneWidget);
    });

    testWidgets('should display watchlist button',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should show check icon when tv series is in watchlist',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: true,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should trigger AddToWatchlist event when watchlist button is tapped and not in watchlist',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      await tester.tap(find.text('Watchlist'));

      // assert
      verify(() => mockBloc.add(AddToWatchlist(tTvSeriesDetail))).called(1);
    });

    testWidgets('should trigger RemoveFromWatchlist event when watchlist button is tapped and in watchlist',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: true,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      await tester.tap(find.text('Watchlist'));

      // assert
      verify(() => mockBloc.add(RemoveFromWatchlist(tTvSeriesDetail))).called(1);
    });

    testWidgets('should display snackbar when watchlist message is not empty',
        (WidgetTester tester) async {
      // arrange
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TvSeriesDetailState.initial().copyWith(
            tvSeriesDetail: tTvSeriesDetail,
            recommendations: [],
          ),
          TvSeriesDetailState.initial().copyWith(
            tvSeriesDetail: tTvSeriesDetail,
            recommendations: [],
            watchlistMessage: 'Added to Watchlist',
          ),
        ]),
        initialState: TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets('should display recommendations when available',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [tTvSeries],
          isAddedToWatchlist: false,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Recommendations'), findsOneWidget);
    });

    testWidgets('should display loading indicator for recommendations when loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isRecommendationsLoading: true,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should display error message for recommendations when error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          recommendationsMessage: 'Failed to load recommendations',
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Failed to load recommendations'), findsOneWidget);
    });

    testWidgets('should display no recommendations message when list is empty',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('No recommendations'), findsOneWidget);
    });

    testWidgets('should display seasons information',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('7 Episodes'), findsOneWidget);
    });

    testWidgets('should display genres',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Drama'), findsOneWidget);
    });

    testWidgets('should display tv series info',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.text('Status:'), findsOneWidget);
      expect(find.text('Ended'), findsOneWidget);
      expect(find.text('Type:'), findsOneWidget);
      expect(find.text('Scripted'), findsOneWidget);
      expect(find.text('Seasons:'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Episodes:'), findsOneWidget);
      expect(find.text('62'), findsOneWidget);
    });

    testWidgets('should have back button',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial().copyWith(
          tvSeriesDetail: tTvSeriesDetail,
          recommendations: [],
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      // assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should call FetchTvSeriesDetail and LoadWatchlistStatus on init',
        (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(
        TvSeriesDetailState.initial(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      verify(() => mockBloc.add(const FetchTvSeriesDetail(1))).called(1);
      verify(() => mockBloc.add(const LoadWatchlistStatus(1))).called(1);
    });
  });
}
