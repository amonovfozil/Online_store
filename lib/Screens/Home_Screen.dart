import 'package:flutter/material.dart';
import 'package:online_market/widgets/Cart_icon.dart';
import 'package:online_market/widgets/Sidebar.dart';
import 'package:online_market/widgets/part_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isfavorityPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        title: Text('Magazin'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == 0) {
                  isfavorityPage = false;
                } else {
                  isfavorityPage = true;
                }
              });
            },
            itemBuilder: ((context) {
              return [
                PopupMenuItem(
                  child: Text('Barchasi'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Sevimli'),
                  value: 1,
                ),
              ];
            }),
          ),
          CartIcon(),
        ],
      ),
      drawer: SideBar(),
      body: part_home(isfavorityPage: isfavorityPage),
    );
  }
}
