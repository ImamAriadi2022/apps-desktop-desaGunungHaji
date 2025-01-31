import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExcelManager(),
    );
  }
}

class ExcelManager extends StatefulWidget {
  @override
  _ExcelManagerState createState() => _ExcelManagerState();
}

class _ExcelManagerState extends State<ExcelManager> {
  var excel;
  List<String> sheetNames = [];
  var sheet;
  Map<String, String> data = {};

  // Membuka dan membaca file Excel
  Future<void> openExcel() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      var bytes = result.files.single.bytes;
      excel = Excel.decodeBytes(bytes!);
      setState(() {
        sheetNames = excel.tables.keys.toList();  // Menyimpan nama sheet
        sheet = excel.tables[sheetNames[0]];     // Memilih sheet pertama secara default
        extractDataFromSheet();  // Menyaring data pertama dari sheet
      });
    }
  }

  // Fungsi untuk mengekstrak data dari sheet yang dipilih
  void extractDataFromSheet() {
    var row = sheet?.rows[3];  // Mengakses baris ke-4 (indeks 3)
    if (row != null) {
      data = {
        'Nomor': row[0]?.toString() ?? '',
        'Nomor KK': row[1]?.toString() ?? '',
        'NIK': row[2]?.toString() ?? '',
        'Nama': row[3]?.toString() ?? '',
        'Kelamin': row[4]?.toString() ?? '',
        'Tanggal Lahir': row[6]?.toString() ?? '',
        'RT/RW': row[7]?.toString() ?? '',
        'Agama': row[8]?.toString() ?? '',
        'Pendidikan Terakhir': row[9]?.toString() ?? '',
        'Pekerjaan': row[10]?.toString() ?? '',
        'Status': row[11]?.toString() ?? '',
        'Status di Keluarga': row[12]?.toString() ?? '',
        'Nama Ayah': row[13]?.toString() ?? '',
        'Nama Ibu': row[14]?.toString() ?? '',
        'Umur Tahun': row[15]?.toString() ?? '',
        'Umur Bulan': row[16]?.toString() ?? '',
        'Umur Hari': row[17]?.toString() ?? '',
      };
    }
  }

  // Menyimpan data kembali ke file Excel
  Future<void> saveExcel() async {
    // Logika untuk menyimpan data kembali ke file Excel (implementasi bisa lebih kompleks tergantung kebutuhan)
    print('Data telah disimpan');
  }

  // Menampilkan data dalam form untuk edit
  Widget buildDataDisplay() {
    return Column(
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: entry.value,
                  onChanged: (value) {
                    setState(() {
                      data[entry.key] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Menampilkan sheet picker untuk memilih sheet yang ingin dibuka
  Widget buildSheetPicker() {
    return DropdownButton<String>(
      value: sheetNames.isNotEmpty ? sheetNames[0] : null,
      items: sheetNames.map((sheetName) {
        return DropdownMenuItem<String>(
          value: sheetName,
          child: Text(sheetName),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          sheet = excel.tables[value];
          extractDataFromSheet();
        });
      },
      hint: Text("Pilih Sheet"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveExcel,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: openExcel,
              child: Text('Buka File Excel'),
            ),
            if (sheetNames.isNotEmpty) ...[
              buildSheetPicker(),
              SizedBox(height: 20),
              buildDataDisplay(),
            ]
          ],
        ),
      ),
    );
  }
}
