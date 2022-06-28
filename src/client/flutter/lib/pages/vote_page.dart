import 'package:bo_cyberacy/models/entities/department.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/services/geo_service.dart';
import 'package:bo_cyberacy/pages/election/add_election.dart';
import 'package:bo_cyberacy/widgets/interactive_map.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entities/election.dart';
import '../models/notifications/navigation_notification.dart';
import '../models/services/vote_service.dart';
import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';

class VotePage extends StatefulWidget {
  VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  List<Election> elections = [];
  bool _sortAsc_colId = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: VoteService().getAllElection(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Election>> snapshot) {
          if (snapshot.hasData) {
            if (elections.isEmpty) {
              elections = snapshot.data!;
            }
            return _getTable(context);
          } else if (snapshot.hasError) {
            return _getTable(context);
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
    return elections
        .map(
          (e) => DataRow(
            cells: [
              DataCell(Text(e.id.toString())),
              DataCell(Text(e.name.toString())),
              DataCell(Text(e.getTypeName())),
              DataCell(
                  Text(DateFormat("dd/MM/yyyy HH:mm").format(e.dateStart))),
              DataCell(Text(DateFormat("dd/MM/yyyy HH:mm").format(e.dateEnd))),
            ],
          ),
        )
        .toList();
  }

  List<DataColumn> _getColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("id"),
        numeric: true,
        onSort: (columnIndex, sortAscending) {
          setState(() {
            _sortAsc_colId = !_sortAsc_colId;
            if (_sortAsc_colId) {
              elections.sort((a, b) => a.id.compareTo(b.id));
            } else {
              elections.sort((a, b) => b.id.compareTo(a.id));
            }
          });
        },
      ),
      const DataColumn(label: Text("nom")),
      const DataColumn(label: Text("type")),
      const DataColumn(label: Text("date debut")),
      const DataColumn(label: Text("date fin"))
    ];
  }

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter une élection",
      width: 300,
      height: 100,
      color: Theme.of(context).highlightColor,
      onTap: () => NavigationNotification(AddElectionPage()).dispatch(context),
    );
  }
}
