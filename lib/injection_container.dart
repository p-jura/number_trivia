import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_tivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_tivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_tivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.asNewInstance();

Future<void> init() async {
  //! Features - Number Trivia
  // bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );
  // use cases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(sl()),
  );
  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(sl()),
  );
  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(
    () => InputConverter(),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  //! External
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
