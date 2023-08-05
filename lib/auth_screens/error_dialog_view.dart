import 'package:flutter/material.dart';

Future<void> showErrorDialog(context, String error) {
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        );
      }
  );
}
