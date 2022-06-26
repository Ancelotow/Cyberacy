import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../models/entities/vote.dart';
import '../models/services/vote_service.dart';
import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';

class VotePage extends StatefulWidget {
  VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  List<Vote> votes = [];
  bool _sortAsc_colId = true;
  late MapShapeSource _mapSource;
  late List<Model> _data;

  @override
  void initState() {
    _data = const <Model>[
      Model('Auvergne-Rhône-Alpes', Color.fromRGBO(255, 215, 0, 1.0),
          'Auvergne-Rhône-Alpes'),
      Model('Bourgogne-Franche-Comté', Color.fromRGBO(72, 209, 204, 1.0), 'Bourgogne-Franche-Comté'),
      Model('Bretagne', Color.fromRGBO(255, 78, 66, 1.0),
          'Bretagne'),
      Model('Centre-Val de Loire', Color.fromRGBO(171, 56, 224, 0.75), 'Centre-Val de Loire'),
      Model('Corse', Color.fromRGBO(126, 247, 74, 0.75),
          'Corse'),
      Model('Grand Est', Color.fromRGBO(79, 60, 201, 0.7),
          'Grand Est'),
      Model('Hauts-de-France', Color.fromRGBO(99, 164, 230, 1), 'Hauts-de-France'),
      Model('Île-de-France', Colors.teal, 'Île-de-France'),
      Model('Normandie', Color.fromRGBO(125, 32, 185, 1.0), 'Normandie'),
      Model('Nouvelle-Aquitaine', Color.fromRGBO(99, 230, 140, 1.0), 'Nouvelle-Aquitaine'),
      Model('Occitanie', Color.fromRGBO(133, 16, 86, 1.0), 'Occitanie'),
      Model('Pays de la Loire', Color.fromRGBO(121, 5, 18, 1.0), 'Pays de la Loire'),
      Model('Provence-Alpes-Côte d\'Azur', Color.fromRGBO(175, 63, 16, 1.0), 'Provence-Alpes-Côte d\'Azur'),
    ];

    _mapSource = MapShapeSource.asset(
      'maps/france_reg.json',
      shapeDataField: 'nom',
      dataCount: _data.length,
      primaryValueMapper: (int index) => _data[index].state,
      dataLabelMapper: (int index) => _data[index].stateCode,
      shapeColorValueMapper: (int index) => _data[index].color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: VoteService().getAllVote(),
        builder: (BuildContext context, AsyncSnapshot<List<Vote>> snapshot) {
          if (snapshot.hasData) {
            if (votes.isEmpty) {
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
    return SingleChildScrollView(
      child: Column(
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
          const SizedBox(height: 20),
          Container(
            width: 500,
            height: 500,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getMap(context),
            ),
          ),
        ],
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
              DataCell(Text(e.getTypeName())),
              DataCell(Text(e.getLocalite())),
              DataCell(Text(e.getDateStartStr()))
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
      const DataColumn(label: Text("date debut"))
    ];
  }

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter un vote",
      width: 300,
      height: 100,
      color: Theme.of(context).highlightColor,
      onTap: () => {},
    );
  }

  Widget _getMap(BuildContext context) {
    return SfMaps(
      layers: <MapShapeLayer>[
        MapShapeLayer(
          source: _mapSource,
          showDataLabels: true,
          legend: const MapLegend(MapElement.shape),
          tooltipSettings: MapTooltipSettings(
              color: Colors.grey[700],
              strokeColor: Colors.white,
              strokeWidth: 2),
          strokeColor: Colors.white,
          strokeWidth: 0.5,
          shapeTooltipBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _data[index].stateCode,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          dataLabelSettings: MapDataLabelSettings(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.caption!.fontSize)),
        ),
      ],
    );
  }
}

/// Collection of Australia state code data.
class Model {
  /// Initialize the instance of the [Model] class.
  const Model(this.state, this.color, this.stateCode);

  /// Represents the Australia state name.
  final String state;

  /// Represents the Australia state color.
  final Color color;

  /// Represents the Australia state code.
  final String stateCode;
}
