import 'package:flutter/cupertino.dart';
import 'package:online_market/models/Carts_model.dart';

class Order {
  final String id;
  final double totalPrice;
  final DateTime days;
  List<cart> cartiteam;
  Order({
    required this.id,
    required this.totalPrice,
    required this.days,
    required this.cartiteam,
  });
}

class orderIteam with ChangeNotifier {
  List<Order> _Orders = [];

  List<Order> get lists {
    return _Orders;
  }

  void addOrder(double TotalPrice, List<cart> Carts) {
    _Orders.insert(
        0,
        Order(
            id: UniqueKey().toString(),
            totalPrice: TotalPrice,
            days: DateTime.now(),
            cartiteam: Carts));
    notifyListeners();
  }
}
