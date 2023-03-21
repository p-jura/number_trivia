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

class PageControlWidget extends StatefulWidget {
  const PageControlWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PageControlWidget> createState() => _PageControlWidgetState();
}

class _PageControlWidgetState extends State<PageControlWidget> {
  final txController = TextEditingController();
  String inputString = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
      child: Column(
        children: [
          TextField(
            controller: txController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a number',
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) => dispatchConcrete(),
            onChanged: (value) {
              setState(() {
                inputString = value;
              });
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: inputString.isEmpty
                      ? null
                      : () {
                          dispatchConcrete();
                        },
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    dispatchRandom();
                  },
                  child: const Text('Get random Trvia'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void dispatchConcrete() {
    txController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    txController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
