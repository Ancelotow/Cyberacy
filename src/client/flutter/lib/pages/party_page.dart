// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/widgets/card_party.dart';
import 'package:flutter/material.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PartyService().getAllParty(),
      builder: (BuildContext context, AsyncSnapshot<List<PoliticalParty>> snapshot) {
        if (snapshot.hasData) {
          getListParty(snapshot.data);
        } else if(snapshot.hasError) {
          getPartyError();
        } else {
          getPartyLoader();
        }
        return Center();
      },
    );
  }

  Widget getListParty(List<PoliticalParty>? parties) {
    print(parties);
    if(parties == null) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      );
    }
    return Wrap(
      children: parties.map((e) => CardParty(party: e)).toList(),
    );
  }

  Widget getPartyLoader() {
    print('ok2');

    return SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    );
  }

  Widget getPartyError() {
    print('ok3');
    return Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    );
  }

}
