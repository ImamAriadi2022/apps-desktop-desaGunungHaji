import 'package:flutter/material.dart';
import '../models/penduduk.dart';

class DataTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Nama')),
        DataColumn(label: Text('NIK')),
        DataColumn(label: Text('Alamat')),
      ],
      rows: [
        // Data rows would be populated here
        DataRow(cells: [
          DataCell(Text('John Doe')),
          DataCell(Text('123456789')),
          DataCell(Text('Some address')),
        ]),
      ],
    );
  }
}
