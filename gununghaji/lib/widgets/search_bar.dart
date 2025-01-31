import 'package:flutter/material.dart';
import '../providers/data_penduduk_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Cari berdasarkan NIK',
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<DataPendudukProvider>().filterData(query);
      },
    );
  }
}
