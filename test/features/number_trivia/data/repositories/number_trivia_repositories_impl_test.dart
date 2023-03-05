import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_tivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_tivia/domain/etities/number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/repositories/number_trivia_repository.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
import 'number_trivia_repositories_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late int tNumber;
  late NumberTriviaModel tNumberTriviaModel;
  late NumberTrivia tNumberTrivia;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    tNumber = 1;
    tNumberTriviaModel =
        NumberTriviaModel(text: 'text trivia', number: tNumber);
    tNumberTrivia = tNumberTriviaModel;
  });
  group('getConcreteNumberTrivia', () {
    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
  });
  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test('should return remote data when the call to remote data is succes',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => false);
    });
  });
}
