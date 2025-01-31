import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_penduduk_provider.dart';
import 'data_penduduk_screen.dart';
import '../widgets/sidebar_menu.dart';

class DataPendudukScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataPendudukProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Data Penduduk')),
        drawer: SidebarMenu(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataPendudukScreen(),
        ),
      ),
    );
  }
}