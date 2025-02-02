import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _formData = widget.data != null ? Map<String, dynamic>.from(widget.data!) : {};
    _dateController = TextEditingController(
      text: _formData['TGL LAHIR'] ?? '',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_formData['TGL LAHIR'] != null && _formData['TGL LAHIR'].isNotEmpty) {
      initialDate = DateFormat('yyyy-MM-dd').parse(_formData['TGL LAHIR']);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        _formData['TGL LAHIR'] = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = _formData['TGL LAHIR'];
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_formData['TGL LAHIR'] != null && _formData['TGL LAHIR'].isNotEmpty) {
      DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_formData['TGL LAHIR']);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      int months = (today.month - birthDate.month) % 12;
      int days = (today.difference(birthDate).inDays % 365) % 30;
      setState(() {
        _formData['TAHUN'] = age.toString();
        _formData['BULAN'] = months.toString();
        _formData['HARI'] = days.toString();
      });
    }
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
                initialValue: _formData['No'] ?? '',
                decoration: InputDecoration(labelText: 'No'),
                readOnly: true, // No tidak bisa diedit
              ),
              TextFormField(
                initialValue: _formData['No KK'] ?? '',
                decoration: InputDecoration(labelText: 'No KK'),
                onSaved: (value) {
                  _formData['No KK'] = value;
                },
              ),
              TextFormField(
                initialValue: _formData['NIK'] ?? '',
                decoration: InputDecoration(labelText: 'NIK'),
                onSaved: (value) {
                  _formData['NIK'] = value;
                },
              ),
              TextFormField(
                initialValue: _formData['NAMA'] ?? '',
                decoration: InputDecoration(labelText: 'Nama'),
                onSaved: (value) {
                  _formData['NAMA'] = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: _formData['JK'],
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['L', 'P'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['JK'] = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _formData['TTL'] ?? '',
                decoration: InputDecoration(labelText: 'Tempat Lahir'),
                onSaved: (value) {
                  _formData['TTL'] = value;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              TextFormField(
                initialValue: _formData['RT/RW'] ?? '',
                decoration: InputDecoration(labelText: 'RT/RW'),
                onSaved: (value) {
                  _formData['RT/RW'] = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: _formData['AGAMA'],
                decoration: InputDecoration(labelText: 'Agama'),
                items: ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['AGAMA'] = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _formData['PENDIDIKAN'],
                decoration: InputDecoration(labelText: 'Pendidikan Terakhir'),
                items: ['SD', 'SMP', 'SMA/SLTA', 'D1', 'D2', 'D3', 'S1', 'S2', 'S3'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['PENDIDIKAN'] = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _formData['J. PEKERJAAN'] ?? '',
                decoration: InputDecoration(labelText: 'Jenis Pekerjaan'),
                onSaved: (value) {
                  _formData['J. PEKERJAAN'] = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: _formData['S. PKAWIN'],
                decoration: InputDecoration(labelText: 'Status Perkawinan'),
                items: ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['S. PKAWIN'] = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _formData['SHDK'],
                decoration: InputDecoration(labelText: 'Status Hubungan Dalam Keluarga'),
                items: ['Kepala Keluarga', 'Istri', 'Anak'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['SHDK'] = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _formData['AYAH'] ?? '',
                decoration: InputDecoration(labelText: 'Nama Ayah'),
                onSaved: (value) {
                  _formData['AYAH'] = value;
                },
              ),
              TextFormField(
                initialValue: _formData['IBU'] ?? '',
                decoration: InputDecoration(labelText: 'Nama Ibu'),
                onSaved: (value) {
                  _formData['IBU'] = value;
                },
              ),
              TextFormField(
                initialValue: _formData['TAHUN'] ?? '',
                decoration: InputDecoration(labelText: 'Tahun'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: _formData['BULAN'] ?? '',
                decoration: InputDecoration(labelText: 'Bulan'),
                readOnly: true,
              ),
              TextFormField(
                initialValue: _formData['HARI'] ?? '',
                decoration: InputDecoration(labelText: 'Hari'),
                readOnly: true,
              ),
              SizedBox(height: 20),
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