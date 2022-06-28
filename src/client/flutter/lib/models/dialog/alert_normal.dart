import 'package:flutter/material.dart';
import '../../widgets/buttons/button.dart';

class AlertNormal {
  String title;
  String message;
  String labelButton;
  BuildContext context;

  AlertNormal({
    required this.title,
    required this.message,
    required this.labelButton,
    required this.context,
  });

  void show() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          Button(
            width: 100,
            label: labelButton,
            click: () {
              Navigator.pop(_);
            },
          )
        ],
        elevation: 30.00,
      ),
    );
  }
}
