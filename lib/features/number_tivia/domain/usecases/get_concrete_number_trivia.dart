import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecases/usecases.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia,Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});
  
  @override
   List<Object?> get props => [number];

}