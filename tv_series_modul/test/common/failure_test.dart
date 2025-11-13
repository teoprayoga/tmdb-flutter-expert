import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/common/failure.dart';

void main() {
  group('ServerFailure', () {
    test('should contain message property', () {
      const message = 'Server failure message';
      const result = ServerFailure(message);

      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      const failure = ServerFailure('message');
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      const failure1 = ServerFailure('message');
      const failure2 = ServerFailure('message');
      const failure3 = ServerFailure('different message');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });

  group('ConnectionFailure', () {
    test('should contain message property', () {
      const message = 'Connection failure message';
      const result = ConnectionFailure(message);

      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      const failure = ConnectionFailure('message');
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      const failure1 = ConnectionFailure('message');
      const failure2 = ConnectionFailure('message');
      const failure3 = ConnectionFailure('different message');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });

  group('DatabaseFailure', () {
    test('should contain message property', () {
      const message = 'Database failure message';
      const result = DatabaseFailure(message);

      expect(result.message, message);
    });

    test('should be a subclass of Failure', () {
      const failure = DatabaseFailure('message');
      expect(failure, isA<Failure>());
    });

    test('should have correct props for equality', () {
      const failure1 = DatabaseFailure('message');
      const failure2 = DatabaseFailure('message');
      const failure3 = DatabaseFailure('different message');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });
}
