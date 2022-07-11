import 'package:bo_cyberacy/models/entities/meeting.dart';
import 'package:bo_cyberacy/models/services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';
import '../widgets/cards/card_state_progress.dart';
import '../widgets/info_error.dart';

class MeetingsPage extends StatelessWidget {
  List<Meeting> meetings = [];

  MeetingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: MeetingService().getAllMeetings(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.hasData) {
            if (meetings.isEmpty) {
              meetings = snapshot.data!;
            }
            return _getTable(context);
          } else if (snapshot.hasError) {
            return InfoError(error: snapshot.error as Error);
          } else {
            return _getTableLoader(context);
          }
        },
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

  Widget _getTable(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _getButtonAdd(context),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                offset: Offset(1, 1), // Shadow position
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return Theme.of(context).accentColor.withOpacity(0.08);
                return Theme.of(context)
                    .highlightColor
                    .withOpacity(0.5); // Use the default value.
              }),
              columnSpacing: 100.0,
              columns: _getColumns(context),
              rows: _getRows(context),
            ),
          ),
        ),
      ],
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
              DataCell(Text("${e.priceExcl.toString()} €")),
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
      const DataColumn(label: Text("adresse (complète)")),
      const DataColumn(
        label: Text("prix HT"),
        numeric: true,
      ),
      const DataColumn(label: Text("état")),
    ];
  }

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter un meeting",
      width: 300,
      height: 100,
      color: Theme.of(context).highlightColor,
      onTap: () => {},
    );
  }
}
