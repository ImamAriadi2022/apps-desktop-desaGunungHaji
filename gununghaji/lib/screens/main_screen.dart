import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'data_penduduk_screen.dart';
import 'bantuan_screen.dart';
import '../widgets/sidebar_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Penduduk')),
      drawer: SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DashboardScreen(),
      ),
    );
  }
}
