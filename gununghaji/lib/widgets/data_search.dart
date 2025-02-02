import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  final String filePath;
  final Future<List<Map<String, dynamic>>> Function(String, String) searchData;
  final Function resetData;

  DataSearch(this.filePath, this.searchData, this.resetData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          resetData();
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: searchData('NAMA', query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Data tidak ada'));
        } else {
          var data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return ListTile(
                title: Text(item['NAMA'] ?? 'No Name'),
                subtitle: Text('NIK: ${item['NIK'] ?? 'No NIK'}'),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}