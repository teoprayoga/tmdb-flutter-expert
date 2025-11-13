import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RequestState', () {
    test('should have Empty state', () {
      // arrange
      const state = RequestState.Empty;

      // assert
      expect(state, RequestState.Empty);
      expect(state, isA<RequestState>());
    });

    test('should have Loading state', () {
      // arrange
      const state = RequestState.Loading;

      // assert
      expect(state, RequestState.Loading);
      expect(state, isA<RequestState>());
    });

    test('should have Loaded state', () {
      // arrange
      const state = RequestState.Loaded;

      // assert
      expect(state, RequestState.Loaded);
      expect(state, isA<RequestState>());
    });

    test('should have Error state', () {
      // arrange
      const state = RequestState.Error;

      // assert
      expect(state, RequestState.Error);
      expect(state, isA<RequestState>());
    });

    test('should have exactly 4 states', () {
      // assert
      expect(RequestState.values.length, 4);
    });

    test('should be able to compare states', () {
      // arrange
      const state1 = RequestState.Empty;
      const state2 = RequestState.Empty;
      const state3 = RequestState.Loading;

      // assert
      expect(state1 == state2, true);
      expect(state1 == state3, false);
    });

    test('should be able to use in switch statement', () {
      // arrange
      const state = RequestState.Loading;
      String result = '';

      // act
      switch (state) {
        case RequestState.Empty:
          result = 'empty';
          break;
        case RequestState.Loading:
          result = 'loading';
          break;
        case RequestState.Loaded:
          result = 'loaded';
          break;
        case RequestState.Error:
          result = 'error';
          break;
      }

      // assert
      expect(result, 'loading');
    });
  });
}
