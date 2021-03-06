import 'package:bo_cyberacy/models/entities/meeting.dart';
import 'package:bo_cyberacy/models/services/meeting_service.dart';
import 'package:bo_cyberacy/pages/election/list_vote.dart';
import 'package:bo_cyberacy/pages/meeting/add_meeting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/notifications/navigation_notification.dart';
import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';
import '../widgets/cards/card_state_progress.dart';
import '../widgets/info_error.dart';
import '../widgets/table/grid_controle.dart';

class MeetingsPage extends StatelessWidget {
  List<Meeting> meetings = [];

  MeetingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: MeetingService().getAllMeetings(),
          builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
            if (snapshot.hasData) {
              if (meetings.isEmpty) {
                meetings = snapshot.data!;
              }
              return GridControl(
                columns: _getColumns(context),
                rows: _getRows(context),
                button: _getButtonAdd(context),
              );
            } else if (snapshot.hasError) {
              return InfoError(error: snapshot.error as Error);
            } else {
              return _getTableLoader(context);
            }
          },
        ),
      ),
    );
  }

  Widget _getTableLoader(BuildContext context) {
    final List<Widget> cardLoad = List.filled(
      50,
      CardShimmer(
        height: 50,
      ),
    );
    return Container(
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: cardLoad,
      ),
    );
  }

  List<DataRow> _getRows(BuildContext context) {
    return meetings
        .map(
          (e) => DataRow(
            cells: [
              DataCell(Text(e.id.toString())),
              DataCell(Text(e.name.toString())),
              DataCell(
                  Text(DateFormat("dd/MM/yyyy HH:mm").format(e.dateStart))),
              DataCell(Text(e.getFullAddress())),
              DataCell(Text("${e.priceExcl.toString()} ???")),
              DataCell(CardStateProgress(stateProgress: e.getStateProgress())),
            ],
          ),
        )
        .toList();
  }

  List<DataColumn> _getColumns(BuildContext context) {
    return [
      const DataColumn(
        label: Text("id"),
        numeric: true,
      ),
      const DataColumn(label: Text("nom")),
      const DataColumn(label: Text("date")),
      const DataColumn(label: Text("adresse (compl??te)")),
      const DataColumn(
        label: Text("prix HT"),
        numeric: true,
      ),
      const DataColumn(label: Text("??tat")),
    ];
  }

  ButtonCard _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter un meeting",
      width: 300,
      height: 100,
      color: Theme.of(context).highlightColor,
      onTap: () => NavigationNotification(AddMeeting()).dispatch(context),
    );
  }
}
