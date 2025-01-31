import 'package:flutter/material.dart';
import '../models/penduduk.dart';

class DataPendudukProvider extends ChangeNotifier {
  List<Penduduk> _dataPenduduk = [];
  List<Penduduk> _filteredData = [];

  List<Penduduk> get filteredData => _filteredData;

  void setData(List<Penduduk> data) {
    _dataPenduduk = data;
    _filteredData = List.from(_dataPenduduk);
    notifyListeners();
  }

  void filterData(String query) {
    _filteredData = _dataPenduduk
        .where((penduduk) => penduduk.name.contains(query))
        .toList();
    notifyListeners();
  }
}
