// ignore_for_file: unnecessary_null_comparison, constant_identifier_names, invalid_use_of_visible_for_testing_member

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecases/usecases.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Faiulure';
const String INVALID_INPUT_MESSAGE =
    'Invalid Input - the number must be a spositive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  late final GetConcreteNumberTrivia getConcreteNumberTrivia;
  late final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<NumberTriviaEvent>(
      (event, emit) async {
        if (event is GetTriviaForConcreteNumber) {
          final inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);

          await inputEither.fold(
            (failure) {
              emit(Error(message: failure.mapFailureToMessage()));
            },
            (integer) async {
              emit(Loading());
              final failureOrTrivia =
                  await getConcreteNumberTrivia(Params(number: integer));
              _emitFaiulureOrTrivia(failureOrTrivia);
            },
          );
        } else if (event is GetTriviaForRandomNumber) {
          emit(Loading());
          final failureOrTrivia = await getRandomNumberTrivia(NoParams());
          _emitFaiulureOrTrivia(failureOrTrivia);

        }
      },
    );
  }
  void _emitFaiulureOrTrivia(Either<Failure, NumberTrivia> failureOrTrivia) {
    failureOrTrivia.fold(
        (failure) => emit(Error(message: failure.mapFailureToMessage())),
        (trivia) => emit(Loaded(trivia)));
  }
}

extension MapFailureToMassage on Failure {
  String mapFailureToMessage() {
    switch (runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case InvalidInputFailure:
        return INVALID_INPUT_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
