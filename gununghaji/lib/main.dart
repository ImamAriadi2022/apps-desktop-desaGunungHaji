import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _data = [];
  String _filePath = '';

  void _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      var shell = Shell();
      var output = await shell.run('python lib/app.py read "$filePath"');
      setState(() {
        _filePath = filePath;
        _data = List<Map<String, dynamic>>.from(json.decode(output.outText));
      });
    } else {
      print('No file selected');
    }
  }

  void _searchData(String key, String value) async {
    var shell = Shell();
    var output = await shell.run('python lib/app.py search "$_filePath" "$key" "$value"');
    setState(() {
      _data = List<Map<String, dynamic>>.from(json.decode(output.outText));
    });
  }

  void _addData(Map<String, dynamic> newData) async {
    var shell = Shell();
    await shell.run('python lib/app.py add "$_filePath" "${json.encode(newData)}"');
    _importFile(); // Refresh data
  }

  void _updateData(String key, String value, Map<String, dynamic> updatedData) async {
    var shell = Shell();
    await shell.run('python lib/app.py update "$_filePath" "$key" "$value" "${json.encode(updatedData)}"');
    _importFile(); // Refresh data
  }

  void _deleteData(String key, String value) async {
    var shell = Shell();
    await shell.run('python lib/app.py delete "$_filePath" "$key" "$value"');
    _importFile(); // Refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Data Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(_filePath, _searchData),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _importFile,
            child: Text('Import Excel File'),
          ),
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

class DataSearch extends SearchDelegate {
  final String filePath;
  final Function(String, String) searchData;

  DataSearch(this.filePath, this.searchData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
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
    searchData('NAMA', query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

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
                      Navigator.pop(context); // Close DetailScreen
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
              Navigator.pop(context); // Close DetailScreen
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

class AddEditScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  AddEditScreen({this.data, required this.onSave});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = widget.data ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null ? 'Add Data' : 'Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['NAMA'],
                decoration: InputDecoration(labelText: 'Nama'),
                onSaved: (value) {
                  _formData['NAMA'] = value;
                },
              ),
              TextFormField(
                initialValue: _formData['NIK'],
                decoration: InputDecoration(labelText: 'NIK'),
                onSaved: (value) {
                  _formData['NIK'] = value;
                },
              ),
              // Tambahkan field lainnya sesuai kebutuhan
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSave(_formData);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}