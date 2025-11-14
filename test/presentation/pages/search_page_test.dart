import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchNotifier])
void main() {
  late MockMovieSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieSearchNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()), duration: Duration(seconds: 1));

    expect(centerFinder, findsAtLeastNWidgets(1));
    expect(progressBarFinder, findsAtLeast(1));
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display empty container when Error or Empty', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(containerFinder, findsWidgets);
  });

  testWidgets('Page should have TextField for search input', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    final textFieldFinder = find.byType(TextField);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(textFieldFinder, findsOneWidget);
  });

  testWidgets('TextField should trigger search on submit', (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockNotifier.fetchMovieSearch('spiderman')).called(1);
  });
}
