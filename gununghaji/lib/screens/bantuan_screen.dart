import 'package:flutter/material.dart';

class BantuanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bantuan')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Halaman Bantuan - Dokumentasi Aplikasi'),
      ),
    );
  }
}
