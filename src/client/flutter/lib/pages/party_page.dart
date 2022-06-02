import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:flutter/material.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PartyService().getAllParty().then((value) => print(value.length)).catchError((error) => print(error));
    return Container(
      child: Text("Hello World!", style: Theme.of(context).textTheme.headline1,),
    );
  }
}
