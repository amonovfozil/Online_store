import 'package:flutter/material.dart';
import 'package:online_market/Screens/Auth_PageScreen.dart';
import 'package:online_market/providers/auth.dart';
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
          ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, ProductList>(
            create: ((context) => ProductList()),
            update: (context, auth, previousProducts) =>
                previousProducts!..getAuthToken(auth.Token!, auth.UserID!),
          ),
          ChangeNotifierProvider<CartIteams>(
            create: ((context) => CartIteams()),
          ),
          ChangeNotifierProxyProvider<AuthProvider, orderIteam>(
            create: ((context) => orderIteam()),
            update: (context, auth, previousOrders) =>
                previousOrders!..GetAuthToken(auth.Token!),
          )
        ],
        child: Consumer<AuthProvider>(builder: ((context, AuthData, child) {
          return MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.teal.shade600, primarySwatch: Colors.teal),
            debugShowCheckedModeBanner: false,
            home: AuthData.isAuth ? HomeScreen() : AuthScreen(),
            routes: {
              '/home': (context) => HomeScreen(),
              "CartScreen": (context) => CartScreen(),
              "InfoProduct": (context) => InfoProduct(),
              "Byurtmalar": (context) => OrderPage(),
              "ManegmentScreen": (context) => ManegmentScreen(),
              "EditAddScreen": (context) => EditAddProducScreen(),
            },
          );
        })));
  }
}
