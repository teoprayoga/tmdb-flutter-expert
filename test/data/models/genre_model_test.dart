import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: "Action");

  group('GenreModel', () {
    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "id": 1,
          "name": "Action",
        };

        // act
        final result = GenreModel.fromJson(jsonMap);

        // assert
        expect(result, equals(tGenreModel));
        expect(result.id, 1);
        expect(result.name, "Action");
      });

      test('should handle different data types in JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          "id": 28,
          "name": "Drama",
        };

        // act
        final result = GenreModel.fromJson(jsonMap);

        // assert
        expect(result.id, 28);
        expect(result.name, "Drama");
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tGenreModel.toJson();

        // assert
        final expectedJsonMap = {
          "id": 1,
          "name": "Action",
        };
        expect(result, equals(expectedJsonMap));
      });

      test('should return a JSON map with correct keys', () {
        // act
        final result = tGenreModel.toJson();

        // assert
        expect(result.containsKey("id"), true);
        expect(result.containsKey("name"), true);
        expect(result["id"], isA<int>());
        expect(result["name"], isA<String>());
      });

      test('should convert to JSON and back to model correctly', () {
        // act
        final json = tGenreModel.toJson();
        final result = GenreModel.fromJson(json);

        // assert
        expect(result, equals(tGenreModel));
      });
    });

    group('toEntity', () {
      test('should return a Genre entity with proper data', () {
        // act
        final result = tGenreModel.toEntity();

        // assert
        final tGenre = Genre(id: 1, name: "Action");
        expect(result, equals(tGenre));
      });

      test('should return an entity with the same values', () {
        // act
        final result = tGenreModel.toEntity();

        // assert
        expect(result.id, tGenreModel.id);
        expect(result.name, tGenreModel.name);
        expect(result.id, 1);
        expect(result.name, "Action");
      });
    });

    group('Equatable props', () {
      test('should have correct props for equality comparison', () {
        // assert
        expect(tGenreModel.props, [1, "Action"]);
      });

      test('should be equal when all properties are the same', () {
        // arrange
        final tGenreModel1 = GenreModel(id: 1, name: "Action");
        final tGenreModel2 = GenreModel(id: 1, name: "Action");

        // assert
        expect(tGenreModel1, equals(tGenreModel2));
      });

      test('should not be equal when properties are different', () {
        // arrange
        final tGenreModel1 = GenreModel(id: 1, name: "Action");
        final tGenreModel2 = GenreModel(id: 2, name: "Drama");

        // assert
        expect(tGenreModel1, isNot(equals(tGenreModel2)));
      });

      test('should not be equal when only id is different', () {
        // arrange
        final tGenreModel1 = GenreModel(id: 1, name: "Action");
        final tGenreModel2 = GenreModel(id: 2, name: "Action");

        // assert
        expect(tGenreModel1, isNot(equals(tGenreModel2)));
      });

      test('should not be equal when only name is different', () {
        // arrange
        final tGenreModel1 = GenreModel(id: 1, name: "Action");
        final tGenreModel2 = GenreModel(id: 1, name: "Drama");

        // assert
        expect(tGenreModel1, isNot(equals(tGenreModel2)));
      });
    });
  });
}
