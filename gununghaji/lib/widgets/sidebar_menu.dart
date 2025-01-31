import 'package:flutter/material.dart';
import '../screens/data_penduduk_screen_wrapper.dart';
import '../screens/dashboard_screen_wrapper.dart';
import '../screens/bantuan_screen.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreenWrapper()),
              );
            },
          ),
          ListTile(
            title: Text('Data Penduduk'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DataPendudukScreenWrapper()),
              );
            },
          ),
          ListTile(
            title: Text('Bantuan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BantuanScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}