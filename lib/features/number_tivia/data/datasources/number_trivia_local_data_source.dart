import 'package:number_trivia/features/number_tivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] wich was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throw [CacheExeption] if no chached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNuberTrivia(NumberTriviaModel triviaToCache);
}
