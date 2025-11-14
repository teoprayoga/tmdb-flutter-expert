import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenre = Genre(
    id: 1,
    name: 'Action',
  );

  group('Genre', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tGenre, isA<Object>());
    });

    test('should have correct props', () {
      // assert
      expect(tGenre.props, [1, 'Action']);
    });

    test('should create instance with correct values', () {
      // assert
      expect(tGenre.id, 1);
      expect(tGenre.name, 'Action');
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final genre1 = Genre(id: 1, name: 'Action');
        final genre2 = Genre(id: 1, name: 'Action');

        // assert
        expect(genre1, equals(genre2));
      });

      test('should not be equal when id is different', () {
        // arrange
        final genre1 = Genre(id: 1, name: 'Action');
        final genre2 = Genre(id: 2, name: 'Action');

        // assert
        expect(genre1, isNot(equals(genre2)));
      });

      test('should not be equal when name is different', () {
        // arrange
        final genre1 = Genre(id: 1, name: 'Action');
        final genre2 = Genre(id: 1, name: 'Drama');

        // assert
        expect(genre1, isNot(equals(genre2)));
      });
    });
  });
}
