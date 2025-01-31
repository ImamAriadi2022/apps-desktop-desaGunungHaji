import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExcelHelper {
  static Future<void> importExcel(String filePath) async {
    var file = File(filePath);
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);
    // Process the data from Excel file
  }

  static Future<void> exportExcel(List<List<String>> data) async {
    var excel = Excel.createExcel();
    // Process and write data to Excel file
    var directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/data_penduduk.xlsx');
    await file.writeAsBytes(excel.encode()!);
  }
}
