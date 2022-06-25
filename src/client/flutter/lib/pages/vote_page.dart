import 'package:flutter/material.dart';

import '../models/entities/vote.dart';
import '../models/services/vote_service.dart';
import '../widgets/cards/card_shimmer.dart';

class VotePage extends StatefulWidget {
  VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  List<Vote> votes = [];
  bool _sortAsc_colId = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: VoteService().getAllVote(),
          builder: (BuildContext context, AsyncSnapshot<List<Vote>> snapshot) {
            if (snapshot.hasData) {
              if(votes.isEmpty) {
                votes = snapshot.data!;
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
      width: MediaQuery.of(context).size.width,
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
    return SizedBox(
      width: double.infinity,
      child: Container(
        color: Theme.of(context).cardColor,
        child: DataTable(
          columnSpacing: 100.0,
          columns: _getColumns(context),
          rows: _getRows(context),
        ),
      ),
    );
  }

  List<DataRow> _getRows(BuildContext context) {
    return votes
        .map(
          (e) => DataRow(
            cells: [
              DataCell(Text(e.id!.toString())),
              DataCell(Text(e.name!.toString())),
              DataCell(Text("test type")),
              DataCell(Text("test localité")),
              DataCell(Text("test date début")),
              DataCell(Text("test date fin")),
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
              votes.sort((a, b) => a.id!.compareTo(b.id!));
            } else {
              votes.sort((a, b) => b.id!.compareTo(a.id!));
            }
          });
        },
      ),
      const DataColumn(label: Text("nom")),
      const DataColumn(label: Text("type")),
      const DataColumn(label: Text("localité")),
      const DataColumn(label: Text("date debut")),
      const DataColumn(label: Text("date fin")),
    ];
  }
}
