import 'package:flutter/material.dart';
import '../../widgets/buttons/button.dart';

class AlertYesNo {
  String title;
  String message;
  String labelButtonNo;
  String labelButtonYes;
  Function() callback;
  BuildContext context;

  AlertYesNo({
    required this.title,
    required this.message,
    required this.callback,
    this.labelButtonNo = "Non",
    this.labelButtonYes = "Oui",
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
            label: labelButtonYes,
            click: callback,
          ),
          Button(
            width: 100,
            color: Colors.red,
            pressedColor: Colors.redAccent,
            label: labelButtonNo,
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
