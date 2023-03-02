import 'dart:convert';

import 'package:http/http.dart' as http;
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

  String? _Token;
  String? _userID;
  void GetAuthToken(String? token, String? UserID) {
    _Token = token;
    _userID = UserID;
  }

  Future<void> GetOrderInFirebase() async {
    final url = Uri.parse(
        'https://marketdatebase-default-rtdb.firebaseio.com/$_userID/orders.json?auth=$_Token');
    try {
      final DataFrebase = await http.get(url);
      if (jsonDecode(DataFrebase.body) != null) {
        final DataOrder = jsonDecode(DataFrebase.body) as Map<String, dynamic>;
        final List<Order> loadOrderData = [];

        DataOrder.forEach((orderId, order) {
          loadOrderData.insert(
            0,
            Order(
              id: orderId,
              totalPrice: order['totalPrice'],
              days: DateTime.parse(order['date']),
              cartiteam: (order['cartiteam'] as List<dynamic>)
                  .map(
                    (cartt) => cart(
                      id: cartt["id"],
                      Title: cartt['title'],
                      photo: cartt['photo'],
                      amount: cartt['amount'],
                      price: cartt["price"],
                    ),
                  )
                  .toList(),
            ),
          );
        });
        _Orders = loadOrderData;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(double TotalPrice, List<cart> Carts) async {
    final url = Uri.parse(
        'https://marketdatebase-default-rtdb.firebaseio.com/$_userID/orders.json?auth=$_Token');
    try {
      final DataOrder = await http.post(
        url,
        body: jsonEncode(
          {
            "totalPrice": TotalPrice,
            'date': DateTime.now().toIso8601String(),
            "cartiteam": Carts.map(
              (cart) => {
                "id": cart.id,
                'title': cart.Title,
                'price': cart.price,
                'photo': cart.photo,
                "amount": cart.amount
              },
            ).toList(),
          },
        ),
      );
      final dataID =
          (jsonDecode(DataOrder.body) as Map<String, dynamic>)['name'];
      _Orders.insert(
          0,
          Order(
              id: dataID,
              totalPrice: TotalPrice,
              days: DateTime.now(),
              cartiteam: Carts));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
