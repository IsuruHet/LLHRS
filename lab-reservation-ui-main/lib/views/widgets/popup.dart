import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showYesNoPopup(BuildContext context,
    {required Function() onYesClick, required String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(24),
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: onYesClick,
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("No"),
          ),
        ],
      );
    },
  );
}
