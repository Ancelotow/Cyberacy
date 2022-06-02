import 'package:flutter/material.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hello World!", style: Theme.of(context).textTheme.headline1,),
    );
  }
}
