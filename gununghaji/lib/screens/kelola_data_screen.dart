import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';
import '../widgets/data_search.dart';

class KelolaDataScreen extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String filePath;

  KelolaDataScreen({required this.data, required this.filePath});

  @override
  _KelolaDataScreenState createState() => _KelolaDataScreenState();
}

class _KelolaDataScreenState extends State<KelolaDataScreen> {
  late List<Map<String, dynamic>> _data;
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _filePath = widget.filePath;
  }

  // Pencarian data (misalnya berdasarkan NAMA)
  Future<List<Map<String, dynamic>>> _searchData(String key, String value) async {
    var shell = Shell();
    print('Running app.exe with arguments: search, $_filePath, $key, $value');
    var output = await shell.runExecutableArguments(
      'lib/app.exe', [
      'search',
      _filePath,
      key,
      value,
    ]);
    print('Output: ${output.outText}');
    return List<Map<String, dynamic>>.from(json.decode(output.outText));
  }

  // Reset data untuk menampilkan semua data
  void _resetData() async {
    var shell = Shell();
    print('Running app.exe with arguments: read, $_filePath');
    var output = await shell.runExecutableArguments(
      'lib/app.exe', [
      'read',
      _filePath,
    ]);
    print('Output: ${output.outText}');
    if (mounted) {
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(output.outText));
      });
    }
  }

  // Menambahkan data baru
  void _addData(Map<String, dynamic> newData) async {
    var shell = Shell();
    print('Running app.exe with arguments: add, $_filePath, ${json.encode(newData)}');
    await shell.runExecutableArguments(
      'lib/app.exe', [
      'add',
      _filePath,
      json.encode(newData)
    ]);
    if (mounted) {
      setState(() {
        _data.add(newData);
      });
    }
  }

  // Memperbarui data
  void _updateData(String key, String value, Map<String, dynamic> updatedData) async {
    var shell = Shell();
    print('Running app.exe with arguments: update, $_filePath, $key, $value, ${json.encode(updatedData)}');
    await shell.runExecutableArguments(
      'lib/app.exe', [
      'update',
      _filePath,
      key,
      value,
      json.encode(updatedData)
    ]);
    if (mounted) {
      setState(() {
        int index = _data.indexWhere((element) => element[key] == value);
        if (index != -1) {
          _data[index] = updatedData;
        }
      });
    }
  }

  // Menghapus data
  void _deleteData(String key, String value) async {
    var shell = Shell();
    print('Running app.exe with arguments: delete, $_filePath, $key, $value');
    await shell.runExecutableArguments(
      'lib/app.exe', [
      'delete',
      _filePath,
      key,
      value,
    ]);
    if (mounted) {
      setState(() {
        _data.removeWhere((element) => element[key] == value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(_filePath, _searchData, _resetData),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditScreen(
                    onSave: _addData,
                  ),
                ),
              );
            },
            child: Text('Add Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                var item = _data[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(item['NAMA'] ?? 'No Name'),
                    subtitle: Text('NIK: ${item['NIK'] ?? 'No NIK'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            data: item,
                            deleteData: _deleteData,
                            updateData: _updateData,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditScreen(
                                  data: item,
                                  onSave: (updatedData) {
                                    _updateData('NIK', item['NIK'], updatedData);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteData('NIK', item['NIK']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}