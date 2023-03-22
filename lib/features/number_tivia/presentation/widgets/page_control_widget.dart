import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

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
            onSubmitted: (value) =>
                dispatch(GetTriviaForConcreteNumber(inputString)),
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
                          dispatch(GetTriviaForConcreteNumber(inputString));
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
                    dispatch(GetTriviaForRandomNumber());
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

  void dispatch(NumberTriviaEvent event) {
    txController.clear();
    setState(() {
      inputString = '';
    });
    BlocProvider.of<NumberTriviaBloc>(context).add(event);
  }
}
