import 'package:flutter/material.dart';
import '../../models/entities/option.dart';

class CardOptionManif extends StatelessWidget {

  final Option option;

  const CardOptionManif({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: [
            Text(
              "${option.name} : ${option.description}",
              maxLines: 5,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
