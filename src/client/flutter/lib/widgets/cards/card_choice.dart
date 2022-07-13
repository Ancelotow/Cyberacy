import 'package:flutter/material.dart';

import '../../models/entities/choice.dart';

class CardChoice extends StatelessWidget {
  final Choice choice;
  final double width;
  final double height;

  const CardChoice({
    Key? key,
    required this.choice,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width - 16,
                  child: Text(
                    choice.name,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Text(
                  choice.candidate,
                  style: Theme.of(context).textTheme.headline3,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
