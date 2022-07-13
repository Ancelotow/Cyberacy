import 'package:bo_cyberacy/models/entities/election.dart';
import 'package:bo_cyberacy/models/services/vote_service.dart';
import 'package:bo_cyberacy/pages/election/vote_details.dart';
import 'package:bo_cyberacy/widgets/interactive_map.dart';
import 'package:flutter/material.dart';
import '../../models/entities/vote.dart';
import 'package:intl/intl.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../widgets/cards/card_shimmer.dart';
import '../../widgets/info_error.dart';
import '../../widgets/table/grid_controle.dart';

class ListVotePage extends StatelessWidget {
  List<Vote> votes = [];
  final Election election;

  ListVotePage({Key? key, required this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: VoteService().getAllVote(election.id),
        builder: (BuildContext context, AsyncSnapshot<List<Vote>> snapshot) {
          if (snapshot.hasData) {
            if (votes.isEmpty) {
              votes = snapshot.data!;
            }
            return _getBody(context);
          } else if (snapshot.hasError) {
            return InfoError(error: snapshot.error as Error);
          } else {
            return _getTableLoader(context);
          }
        },
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return Column(
      children: [
        Text(
          election.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: GridControl(
                  columns: _getColumns(context),
                  rows: _getRows(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InteractiveMap(
                  datas: _getDataForMap(context),
                  modelPath: _modelPath(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _modelPath() {
    return "assets/maps/france_reg.json";
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
    return votes
        .map(
          (e) => DataRow(
            cells: [
              DataCell(Text(e.name)),
              DataCell(Text(e.nbVoter.toString())),
              DataCell(Text(e.getLocalite())),
            ],
            onSelectChanged: (val) {
              NavigationNotification(VoteDetailsPage(idVote: e.id))
                  .dispatch(context);
            },
          ),
        )
        .toList();
  }

  List<ModelInterativeMap> _getDataForMap(BuildContext context) {
    return votes
        .map(
          (e) => ModelInterativeMap(
            name: e.getLocalite(),
            code: e.getLocalisationCode(),
            color: Colors.black,
          ),
        )
        .toList();
  }

  List<DataColumn> _getColumns(BuildContext context) {
    return [
      const DataColumn(
        label: Text("name"),
        numeric: true,
      ),
      const DataColumn(label: Text("nombre votant")),
      const DataColumn(label: Text("localisation"))
    ];
  }
}
