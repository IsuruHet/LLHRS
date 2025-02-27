import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showSnackBar(
    {required String message,
    required Color bkgColor,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Colors.white, fontSize: 16),
        ),
        IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ))
      ],
    ),
    backgroundColor: bkgColor,
  ));
}
