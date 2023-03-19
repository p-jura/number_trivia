import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/presentation/bloc/number_trivia_bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>()
])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc triviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(
    () {
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();

      triviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter);
    },
  );

  blocTest('initialState should be Empty()',
      // arrange
      build: () => triviaBloc,
      // assert
      verify: (bloc) => expect(bloc.state, equals(Empty())));
  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberParsed = 1;
      const tNumberString = '1';
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
      void setUpInputConverterSuccess() {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
      }

      test(
        'should call the InputConverter to validate and convert string to int',
        () async {
          setUpInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          triviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );
      blocTest(
        'should emit [error] when the input is invalid',
        // arrane
        build: () => triviaBloc,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        // act
        act: (bloc) {
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        // assert

        expect: () {
          return [const Error(message: INVALID_INPUT_MESSAGE)];
        },
      );
      test(
        'should get data frome concrete usecase',
        () async {
          // arrange
          setUpInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          triviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any))
              .timeout(const Duration(seconds: 3));
          // assert
          verify(
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
        },
      );
      blocTest(
        'should emit [loading, loaded] when data is gotten successfully',
        build: () => triviaBloc,
        setUp: () {
          setUpInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
        },
        act: (bloc) {
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        expect: () {
          return [Loading(), const Loaded(tNumberTrivia)];
        },
      );
      blocTest(
        'should emit [loading, Error] when getting data fails',
        build: () => triviaBloc,
        setUp: () {
          setUpInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        act: (bloc) {
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        expect: () {
          return [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)];
        },
      );
      blocTest(
        '''should emit [loading, Error] with proper 
        message for error when getting data fails''',
        build: () => triviaBloc,
        setUp: () {
          setUpInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        act: (bloc) {
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        expect: () {
          return [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
        },
      );
    },
  );
}
