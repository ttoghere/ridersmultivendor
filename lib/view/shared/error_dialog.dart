import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(primary: Colors.red[900]),
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
