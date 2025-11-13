import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerException', () {
    test('should be an instance of Exception', () {
      // arrange
      final exception = ServerException();

      // assert
      expect(exception, isA<Exception>());
    });
  });

  group('DatabaseException', () {
    test('should contain message property', () {
      // arrange
      final message = 'Database error';

      // act
      final exception = DatabaseException(message);

      // assert
      expect(exception.message, message);
    });

    test('should be an instance of Exception', () {
      // arrange
      final exception = DatabaseException('message');

      // assert
      expect(exception, isA<Exception>());
    });
  });
}
