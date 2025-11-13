import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  testWidgets('TvSeriesCard should display image and be tappable',
      (WidgetTester tester) async {
    // Build TvSeriesCard widget
    await tester.pumpWidget(
      makeTestableWidget(TvSeriesCard(testTvSeries)),
    );

    // Verify that CachedNetworkImage is present
    expect(find.byType(CachedNetworkImage), findsOneWidget);

    // Verify that InkWell (tappable) is present
    expect(find.byType(InkWell), findsOneWidget);
  });
}
