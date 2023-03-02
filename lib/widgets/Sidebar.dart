import 'package:flutter/material.dart';
import 'package:online_market/providers/auth.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  Widget CreatMenu(
      BuildContext context, String title, IconData icons, String adress) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () => Navigator.of(context).pushReplacementNamed(adress),
        leading: Icon(icons),
        title: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            centerTitle: true,
          ),
          CreatMenu(context, 'Bosh Sahifa', Icons.home, '/'),
          CreatMenu(context, 'Byurtmalar', Icons.shop_two_sharp, 'Byurtmalar'),
          CreatMenu(context, 'Mahsulotlarni Boshqarish ', Icons.settings,
              'ManegmentScreen'),
          Card(
            elevation: 2,
            child: ListTile(
              onTap: () =>
                  Provider.of<AuthProvider>(context, listen: false).LogOut(),
              leading: Icon(Icons.logout),
              title: Text('Tizimdan Chiqish'),
            ),
          ),
        ],
      ),
    );
  }
}
