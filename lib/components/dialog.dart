import 'package:flutter/material.dart';

import 'button.dart';

void showSimpleErrorDialog(BuildContext context, String errorMsg) {
  showSimpleDialog(context, 'Ups Something went wrong!', errorMsg);
}

void showSimpleDialog(BuildContext context, String title, String errorMsg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.labelMedium),
          content:
              Text(errorMsg, style: Theme.of(context).textTheme.labelSmall),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Dismiss",
                    style: Theme.of(context).textTheme.labelSmall)),
          ],
        );
      });
}
