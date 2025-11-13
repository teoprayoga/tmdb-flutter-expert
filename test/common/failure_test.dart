import 'package:ditonton/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerFailure', () {
    test('should contain message property', () {
      // arrange
      final message = 'Server failure message';

      // act
      final result = ServerFailure(message);

      // assert
      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      // arrange
      final failure = ServerFailure('message');

      // assert
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      // arrange
      final failure1 = ServerFailure('message');
      final failure2 = ServerFailure('message');
      final failure3 = ServerFailure('different message');

      // assert
      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });

  group('ConnectionFailure', () {
    test('should contain message property', () {
      // arrange
      final message = 'Connection failure message';

      // act
      final result = ConnectionFailure(message);

      // assert
      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      // arrange
      final failure = ConnectionFailure('message');

      // assert
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      // arrange
      final failure1 = ConnectionFailure('message');
      final failure2 = ConnectionFailure('message');
      final failure3 = ConnectionFailure('different message');

      // assert
      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });

  group('DatabaseFailure', () {
    test('should contain message property', () {
      // arrange
      final message = 'Database failure message';

      // act
      final result = DatabaseFailure(message);

      // assert
      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      // arrange
      final failure = DatabaseFailure('message');

      // assert
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      // arrange
      final failure1 = DatabaseFailure('message');
      final failure2 = DatabaseFailure('message');
      final failure3 = DatabaseFailure('different message');

      // assert
      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });
}
