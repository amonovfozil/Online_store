import 'package:flutter/material.dart';
import '../Screens/Edit_Add_productScreen.dart';
import '../Screens/magetment_Screen.dart';
import '../Screens/Cart_screen.dart';
import '../Screens/Home_Screen.dart';
import '../Screens/Info_Product.dart';
import '../Screens/Orders_page.dart';
import '../models/Carts_model.dart';
import '../models/Order_model.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductList>(
          create: ((context) => ProductList()),
        ),
        ChangeNotifierProvider<CartIteams>(
          create: ((context) => CartIteams()),
        ),
        ChangeNotifierProvider<orderIteam>(
          create: ((context) => orderIteam()),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.teal.shade600, primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => HomeScreen(),
          "CartScreen": (context) => CartScreen(),
          "InfoProduct": (context) => InfoProduct(),
          "Byurtmalar": (context) => OrderPage(),
          "ManegmentScreen": (context) => ManegmentScreen(),
          "EditAddScreen": (context) => EditAddProducScreen(),
        },
      ),
    );
  }
}
