import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:file_picker/file_picker.dart';
import 'home_screen.dart';
import 'kelola_data_screen.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _data = [];
  String _filePath = '';

  void _onItemTapped(int index) async {
    if (_filePath.isEmpty) {
      await _importFile();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      _filePath = result.files.single.path!;
      var shell = Shell();
      var output = await shell.runExecutableArguments(
          'lib/app.exe', ['read', _filePath]);
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(output.outText));
      });
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
      ),
      body: _selectedIndex == 0
          ? HomeScreen()
          : KelolaDataScreen(data: _data, filePath: _filePath),
      drawer: Sidebar(onItemTapped: _onItemTapped),
    );
  }
}