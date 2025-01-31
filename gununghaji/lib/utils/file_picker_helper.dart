import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  // Fungsi untuk memilih file Excel dari penyimpanan
  static Future<String?> pickExcelFile() async {
    // Memilih file dengan ekstensi .xlsx
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    // Jika pengguna memilih file, kembalikan path file tersebut
    if (result != null) {
      return result.files.single.path;
    }
    return null; // Jika tidak ada file yang dipilih
  }
}
