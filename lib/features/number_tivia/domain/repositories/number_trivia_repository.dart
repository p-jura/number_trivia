import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../etities/number_trivia.dart';

abstract class NumberTriviaRepository{
  Future <Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int? number);
  Future <Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}