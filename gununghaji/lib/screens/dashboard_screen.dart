import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../providers/data_penduduk_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(),
        Consumer<DataPendudukProvider>(
          builder: (context, provider, child) {
            return Expanded(
              child: ListView.builder(
                itemCount: provider.filteredData.length,
                itemBuilder: (context, index) {
                  final data = provider.filteredData[index];
                  return ListTile(
                    title: Text(data.name),
                    subtitle: Text('NIK: ${data.nik}'),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
