import 'dart:convert';

import 'package:number_trivia/core/errors/exception.dart';
import 'package:number_trivia/features/number_tivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

// ignore: constant_identifier_names
const _URL = 'http://numbersapi.com';
// ignore: constant_identifier_names
const _HEADERS = {'Content-Type': 'application/json'};

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) =>
      _getTriviaFromUrl('$_URL/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('$_URL/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: _HEADERS,
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw ServerException();
    }
  }
}
