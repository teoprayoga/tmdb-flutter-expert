import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series_modul/common/exception.dart';

void main() {
  group('ServerException', () {
    test('should contain message property', () {
      const message = 'Server error';
      final exception = ServerException(message);

      expect(exception.message, message);
    });

    test('should be an instance of Exception', () {
      final exception = ServerException('message');
      expect(exception, isA<Exception>());
    });
  });

  group('DatabaseException', () {
    test('should contain message property', () {
      const message = 'Database error';
      final exception = DatabaseException(message);

      expect(exception.message, message);
    });

    test('should be an instance of Exception', () {
      final exception = DatabaseException('message');
      expect(exception, isA<Exception>());
    });
  });
}
