import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia/features/number_tivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/repositories/number_trivia_repository.dart';

@GenerateMocks([NumberTriviaRepository])
import 'number_trivia_repository_test.mocks.dart';

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() async {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const int tNumber = 1;
  const NumberTrivia tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from the repository', () async {
    //arange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    //act
    final result = await usecase(const Params(number: tNumber));

    //assert

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
