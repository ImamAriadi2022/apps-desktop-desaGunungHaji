import 'package:flutter/material.dart';
import 'add_edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, String) deleteData;
  final Function(String, String, Map<String, dynamic>) updateData;

  DetailScreen({required this.data, required this.deleteData, required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditScreen(
                    data: data,
                    onSave: (updatedData) {
                      updateData('NIK', data['NIK'], updatedData);
                      Navigator.pop(context);
                      Navigator.pop(context); // Menutup DetailScreen
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteData('NIK', data['NIK']);
              Navigator.pop(context); // Menutup DetailScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: data.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value ?? 'N/A'),
            );
          }).toList(),
        ),
      ),
    );
  }
}