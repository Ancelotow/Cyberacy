import 'package:flutter/material.dart';

class GridSource extends DataTableSource {
  List<DataRow> rows;

  GridSource({required this.rows});

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return rows[index];
  }

}
