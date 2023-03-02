import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() async {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const int tNumber = 1;
  const NumberTrivia tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  const anyN = 4;
  test('should get trivia for the number from the repository', () async {
    //arange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(anyN))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await usecase.execute(number: tNumber);

    //assert

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
