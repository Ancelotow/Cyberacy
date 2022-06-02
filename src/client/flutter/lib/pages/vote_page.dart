import 'package:flutter/material.dart';

class VotePage extends StatelessWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Vote!", style: Theme.of(context).textTheme.headline1,),
    );
  }
}
