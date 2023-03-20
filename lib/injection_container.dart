import 'package:get_it/get_it.dart';
import 'package:number_trivia/features/number_tivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.asNewInstance();

void init() {
  // Features - Number Trivia

  // bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(concrete: sl(), random: sl(), inputConverter: sl()));
  // Core

  // External
}
