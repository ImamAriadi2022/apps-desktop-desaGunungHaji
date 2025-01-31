import 'package:flutter/material.dart';
import '../utils/file_picker_helper.dart';
import '../utils/excel_helper.dart';

class DataPendudukScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            String? filePath = await FilePickerHelper.pickExcelFile();
            if (filePath != null) {
              await ExcelHelper.importExcel(filePath);
              // Setelah mengimpor, bisa memperbarui tampilan data
            }
          },
          child: Text('Import Data Excel'),
        ),
        // Tampilan data atau elemen lain di sini
      ],
    );
  }
}
