import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/penduduk.dart';

class DataPendudukProvider with ChangeNotifier {
  List<Penduduk> _dataPenduduk = [];
  List<Penduduk> _filteredData = [];
  String? _filePath;

  List<Penduduk> get dataPenduduk => _dataPenduduk;
  List<Penduduk> get filteredData => _filteredData;

  void importData(File file, {String sheetName = 'Sheet1'}) {
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    _dataPenduduk.clear();
    var sheet = excel[sheetName];
    for (var row in sheet!.rows.skip(3)) { // Skip header rows
      if (row.length >= 18) {
        _dataPenduduk.add(Penduduk(
          nomor: row[0]?.value.toString() ?? '',
          noKk: row[1]?.value.toString() ?? '',
          nik: row[2]?.value.toString() ?? '',
          name: row[3]?.value.toString() ?? '',
          kelamin: row[4]?.value.toString() ?? '',
          tanggalLahir: row[5]?.value.toString() ?? '',
          rtRw: row[6]?.value.toString() ?? '',
          agama: row[7]?.value.toString() ?? '',
          pendidikan: row[8]?.value.toString() ?? '',
          pekerjaan: row[9]?.value.toString() ?? '',
          status: row[10]?.value.toString() ?? '',
          statusKeluarga: row[11]?.value.toString() ?? '',
          namaAyah: row[12]?.value.toString() ?? '',
          namaIbu: row[13]?.value.toString() ?? '',
          umurTahun: row[14]?.value.toString() ?? '',
          umurBulan: row[15]?.value.toString() ?? '',
          umurHari: row[16]?.value.toString() ?? '',
        ));
      }
    }
    _filteredData = List.from(_dataPenduduk);
    _filePath = file.path;
    notifyListeners();
  }

  void exportData() async {
    if (_filePath == null) return;

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add header
    sheetObject.appendRow([
      'Nomor', 'No. KK', 'NIK', 'Nama', 'Kelamin', 'Tanggal Lahir', 'RT/RW', 'Agama',
      'Pendidikan', 'Pekerjaan', 'Status', 'Status Keluarga', 'Nama Ayah', 'Nama Ibu',
      'Umur Tahun', 'Umur Bulan', 'Umur Hari'
    ]);

    // Add data
    for (var data in _dataPenduduk) {
      sheetObject.appendRow([
        data.nomor, data.noKk, data.nik, data.name, data.kelamin, data.tanggalLahir,
        data.rtRw, data.agama, data.pendidikan, data.pekerjaan, data.status,
        data.statusKeluarga, data.namaAyah, data.namaIbu, data.umurTahun, data.umurBulan,
        data.umurHari
      ]);
    }

    File(_filePath!)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
  }

  void addData(Penduduk data) {
    _dataPenduduk.add(data);
    _filteredData = List.from(_dataPenduduk);
    notifyListeners();
  }

  void updateData(int index, Penduduk data) {
    _dataPenduduk[index] = data;
    _filteredData = List.from(_dataPenduduk);
    notifyListeners();
  }

  void deleteData(int index) {
    _dataPenduduk.removeAt(index);
    _filteredData = List.from(_dataPenduduk);
    notifyListeners();
  }

  void filterData(String query) {
    if (query.isEmpty) {
      _filteredData = List.from(_dataPenduduk);
    } else {
      _filteredData = _dataPenduduk
          .where((data) =>
              data.nomor.contains(query) ||
              data.noKk.contains(query) ||
              data.nik.contains(query) ||
              data.name.contains(query) ||
              data.kelamin.contains(query) ||
              data.tanggalLahir.contains(query) ||
              data.rtRw.contains(query) ||
              data.agama.contains(query) ||
              data.pendidikan.contains(query) ||
              data.pekerjaan.contains(query) ||
              data.status.contains(query) ||
              data.statusKeluarga.contains(query) ||
              data.namaAyah.contains(query) ||
              data.namaIbu.contains(query) ||
              data.umurTahun.contains(query) ||
              data.umurBulan.contains(query) ||
              data.umurHari.contains(query))
          .toList();
    }
    notifyListeners();
  }
}