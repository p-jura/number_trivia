import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  const DisplayMessage({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}