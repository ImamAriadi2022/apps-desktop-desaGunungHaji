import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_penduduk_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/penduduk.dart';

class DataPendudukScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Penduduk'),
        actions: [
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xlsx'],
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                Provider.of<DataPendudukProvider>(context, listen: false)
                    .importData(file);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Provider.of<DataPendudukProvider>(context, listen: false)
                  .exportData();
            },
          ),
        ],
      ),
      body: Consumer<DataPendudukProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.dataPenduduk.length,
            itemBuilder: (context, index) {
              final data = provider.dataPenduduk[index];
              return ListTile(
                title: Text(data.name),
                subtitle: Text('NIK: ${data.nik}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditDataDialog(
                              data: data,
                              index: index,
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteData(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddDataDialog();
            },
          );
        },
      ),
    );
  }
}

class AddDataDialog extends StatelessWidget {
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController kelaminController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController rtRwController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController statusKeluargaController = TextEditingController();
  final TextEditingController namaAyahController = TextEditingController();
  final TextEditingController namaIbuController = TextEditingController();
  final TextEditingController umurTahunController = TextEditingController();
  final TextEditingController umurBulanController = TextEditingController();
  final TextEditingController umurHariController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Data'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomorController,
              decoration: InputDecoration(labelText: 'Nomor'),
            ),
            TextField(
              controller: noKkController,
              decoration: InputDecoration(labelText: 'No. KK'),
            ),
            TextField(
              controller: nikController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: kelaminController,
              decoration: InputDecoration(labelText: 'Kelamin'),
            ),
            TextField(
              controller: tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            TextField(
              controller: rtRwController,
              decoration: InputDecoration(labelText: 'RT/RW'),
            ),
            TextField(
              controller: agamaController,
              decoration: InputDecoration(labelText: 'Agama'),
            ),
            TextField(
              controller: pendidikanController,
              decoration: InputDecoration(labelText: 'Pendidikan'),
            ),
            TextField(
              controller: pekerjaanController,
              decoration: InputDecoration(labelText: 'Pekerjaan'),
            ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: statusKeluargaController,
              decoration: InputDecoration(labelText: 'Status Keluarga'),
            ),
            TextField(
              controller: namaAyahController,
              decoration: InputDecoration(labelText: 'Nama Ayah'),
            ),
            TextField(
              controller: namaIbuController,
              decoration: InputDecoration(labelText: 'Nama Ibu'),
            ),
            TextField(
              controller: umurTahunController,
              decoration: InputDecoration(labelText: 'Umur Tahun'),
            ),
            TextField(
              controller: umurBulanController,
              decoration: InputDecoration(labelText: 'Umur Bulan'),
            ),
            TextField(
              controller: umurHariController,
              decoration: InputDecoration(labelText: 'Umur Hari'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final data = Penduduk(
              nomor: nomorController.text,
              noKk: noKkController.text,
              nik: nikController.text,
              name: nameController.text,
              kelamin: kelaminController.text,
              tanggalLahir: tanggalLahirController.text,
              rtRw: rtRwController.text,
              agama: agamaController.text,
              pendidikan: pendidikanController.text,
              pekerjaan: pekerjaanController.text,
              status: statusController.text,
              statusKeluarga: statusKeluargaController.text,
              namaAyah: namaAyahController.text,
              namaIbu: namaIbuController.text,
              umurTahun: umurTahunController.text,
              umurBulan: umurBulanController.text,
              umurHari: umurHariController.text,
            );
            Provider.of<DataPendudukProvider>(context, listen: false)
                .addData(data);
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}

class EditDataDialog extends StatelessWidget {
  final Penduduk data;
  final int index;
  final TextEditingController nomorController;
  final TextEditingController noKkController;
  final TextEditingController nikController;
  final TextEditingController nameController;
  final TextEditingController kelaminController;
  final TextEditingController tanggalLahirController;
  final TextEditingController rtRwController;
  final TextEditingController agamaController;
  final TextEditingController pendidikanController;
  final TextEditingController pekerjaanController;
  final TextEditingController statusController;
  final TextEditingController statusKeluargaController;
  final TextEditingController namaAyahController;
  final TextEditingController namaIbuController;
  final TextEditingController umurTahunController;
  final TextEditingController umurBulanController;
  final TextEditingController umurHariController;

  EditDataDialog({required this.data, required this.index})
      : nomorController = TextEditingController(text: data.nomor),
        noKkController = TextEditingController(text: data.noKk),
        nikController = TextEditingController(text: data.nik),
        nameController = TextEditingController(text: data.name),
        kelaminController = TextEditingController(text: data.kelamin),
        tanggalLahirController = TextEditingController(text: data.tanggalLahir),
        rtRwController = TextEditingController(text: data.rtRw),
        agamaController = TextEditingController(text: data.agama),
        pendidikanController = TextEditingController(text: data.pendidikan),
        pekerjaanController = TextEditingController(text: data.pekerjaan),
        statusController = TextEditingController(text: data.status),
        statusKeluargaController = TextEditingController(text: data.statusKeluarga),
        namaAyahController = TextEditingController(text: data.namaAyah),
        namaIbuController = TextEditingController(text: data.namaIbu),
        umurTahunController = TextEditingController(text: data.umurTahun),
        umurBulanController = TextEditingController(text: data.umurBulan),
        umurHariController = TextEditingController(text: data.umurHari);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Data'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomorController,
              decoration: InputDecoration(labelText: 'Nomor'),
            ),
            TextField(
              controller: noKkController,
              decoration: InputDecoration(labelText: 'No. KK'),
            ),
            TextField(
              controller: nikController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: kelaminController,
              decoration: InputDecoration(labelText: 'Kelamin'),
            ),
            TextField(
              controller: tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            TextField(
              controller: rtRwController,
              decoration: InputDecoration(labelText: 'RT/RW'),
            ),
            TextField(
              controller: agamaController,
              decoration: InputDecoration(labelText: 'Agama'),
            ),
            TextField(
              controller: pendidikanController,
              decoration: InputDecoration(labelText: 'Pendidikan'),
            ),
            TextField(
              controller: pekerjaanController,
              decoration: InputDecoration(labelText: 'Pekerjaan'),
            ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: statusKeluargaController,
              decoration: InputDecoration(labelText: 'Status Keluarga'),
            ),
            TextField(
              controller: namaAyahController,
              decoration: InputDecoration(labelText: 'Nama Ayah'),
            ),
            TextField(
              controller: namaIbuController,
              decoration: InputDecoration(labelText: 'Nama Ibu'),
            ),
            TextField(
              controller: umurTahunController,
              decoration: InputDecoration(labelText: 'Umur Tahun'),
            ),
            TextField(
              controller: umurBulanController,
              decoration: InputDecoration(labelText: 'Umur Bulan'),
            ),
            TextField(
              controller: umurHariController,
              decoration: InputDecoration(labelText: 'Umur Hari'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final updatedData = Penduduk(
              nomor: nomorController.text,
              noKk: noKkController.text,
              nik: nikController.text,
              name: nameController.text,
              kelamin: kelaminController.text,
              tanggalLahir: tanggalLahirController.text,
              rtRw: rtRwController.text,
              agama: agamaController.text,
              pendidikan: pendidikanController.text,
              pekerjaan: pekerjaanController.text,
              status: statusController.text,
              statusKeluarga: statusKeluargaController.text,
              namaAyah: namaAyahController.text,
              namaIbu: namaIbuController.text,
              umurTahun: umurTahunController.text,
              umurBulan: umurBulanController.text,
              umurHari: umurHariController.text,
            );
            Provider.of<DataPendudukProvider>(context, listen: false)
                .updateData(index, updatedData);
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}