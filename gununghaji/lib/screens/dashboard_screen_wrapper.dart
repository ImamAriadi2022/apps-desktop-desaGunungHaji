import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_penduduk_provider.dart';
import 'dashboard_screen.dart';
import '../widgets/sidebar_menu.dart';

class DashboardScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataPendudukProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        drawer: SidebarMenu(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DashboardScreen(),
        ),
      ),
    );
  }
}