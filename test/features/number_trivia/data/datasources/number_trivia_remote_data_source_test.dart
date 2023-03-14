import 'dart:convert';
import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exception.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  setUp(
    () {
      mockHttpClient = MockClient();
      dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    },
  );

  void setUpMockHttpClientSuccess200() {
    when(
      mockHttpClient.get(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(
      mockHttpClient.get(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      const int tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
      test(
        '''should perform GET request on URL with number 
      being the endpoint and with application/json header''',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          verify(
            mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );
      test(
        'should return NumberTrivia when the response code is 200',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
          'should throw a ServerExeption when the response code is other than 200',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      });
    },
  );
  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
      test(
        '''should perform GET request on URL with number 
      being the endpoint and with application/json header''',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource.getRandomNumberTrivia();
          // assert
          verify(
            mockHttpClient.get(
              Uri.parse('http://numbersapi.com/random'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );
      test(
        'should return NumberTrivia when the response code is 200',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getRandomNumberTrivia();
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
          'should throw a ServerExeption when the response code is other than 200',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(
            () => call(), throwsA(const TypeMatcher<ServerException>()));
      });
    },
  );
}
