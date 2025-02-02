import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemTapped;

  Sidebar({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Kelola Data'),
            onTap: () {
              onItemTapped(1);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}