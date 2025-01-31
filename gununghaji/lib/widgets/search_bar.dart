import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Cari',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }
}