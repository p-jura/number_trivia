import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(
    () {
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();

      bloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter);
    },
  );
  test(
    'initialState should be Empty()',
    () {
      // assert
      expect(bloc.state, equals(Empty()));
    },
  );
  group(
    'GetTriviaForConcreteNumber',
    () {
      const String tNumberString = '1';
      const int tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
      test(
          'should call the InputConverter to validate and convert string to int',
          () {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      });
    },
  );
}
