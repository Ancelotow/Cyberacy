import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entities/step.dart';

class CardStep extends StatelessWidget {
  final StepManif step;
  final double width;
  final int index;

  const CardStep({Key? key, required this.step, required this.width, this.index = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              "$index",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "id : ${step.id}",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: width - (width * 0.50),
                  child: Text(
                    "${step.addressStreet}",
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: width - (width * 0.50),
                  child: Text(
                    "${step.townCodeInsee}, ${step.town}",
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.white,),
                    Text(
                      " : ${DateFormat("dd-MM-yyyy HH:mm").format(step.dateArrived!)}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "lat: ${step.latitude}, lng: ${step.longitude}",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
