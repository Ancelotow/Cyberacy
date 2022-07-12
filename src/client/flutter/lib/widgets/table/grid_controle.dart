import 'package:flutter/material.dart';

import '../buttons/button_card.dart';
import 'grid_source.dart';

class GridControl extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final ButtonCard? button;

  const GridControl({
    Key? key,
    required this.columns,
    required this.rows,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: button,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                offset: Offset(1, 1), // Shadow position
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: SingleChildScrollView(

              scrollDirection: Axis.vertical,
              child: PaginatedDataTable(

                columnSpacing: 100.0,
                columns: columns,
                source: GridSource(
                  rows: rows
                ),
                showCheckboxColumn: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
