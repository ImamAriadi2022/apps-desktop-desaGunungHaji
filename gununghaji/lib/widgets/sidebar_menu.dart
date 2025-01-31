import 'package:flutter/material.dart';
import '../screens/data_penduduk_screen.dart';
import '../screens/dashboard_screen.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Data Penduduk'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataPendudukScreen()),
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
