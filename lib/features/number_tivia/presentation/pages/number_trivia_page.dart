import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Column(
          children: [
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (_, state) {
                if (state is Empty) {
                  return const DisplayMessage(
                    message: 'Search for the number!',
                  );
                } else if (state is Error) {
                  return DisplayMessage(
                    message: state.message,
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else {
                  log('state error');
                  return const DisplayMessage(
                    message: 'Something went wrong',
                  );
                }
              },
            ),
            const PageControlWidget()
          ],
        ),
      ),
    );
  }
}

