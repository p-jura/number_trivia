import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exception.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'number_trivia_local_data_test.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  setUp(
    () {
      mockSharedPreferences = MockSharedPreferences();
      dataSource = NumberTriviaLocalDataSourceImpl(
          sharedPreferences: mockSharedPreferences);
    },
  );
  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
          json.decode(fixture('trivia_cached.json')));
      test(
        'should return NumberTrivia frome SharedPreferences when ther is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('trivia_cached.json'));
          // act
          final result = await dataSource.getLastNumberTrivia();
          // assert
          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should throw CacheExeption when there is not a cached value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // act
          final call = dataSource.getLastNumberTrivia;
          // assert
          expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
        },
      );
    },
  );
  group(
    'cached NumberTrivia',
    () {
      const tNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: 1);
      test(
        'should call SharedPreferences to cache the data',
        () {
          // act
          dataSource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          final expectJsonString = jsonEncode(tNumberTriviaModel.toJson());
          verify(
            mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA,
              expectJsonString,
            ),
          );
        },
      );
    },
  );
}
