import 'package:flutter/cupertino.dart';

class cart {
  final String id;
  final String Title;
  final String photo;
  final double price;
  final int amount;

  cart({
    required this.id,
    required this.Title,
    required this.photo,
    required this.amount,
    required this.price,
  });
}

class CartIteams with ChangeNotifier {
  Map<String, cart> _carts = {};

  Map<String, cart> get Carts {
    return _carts;
  }

  int get TotalCaunt {
    return _carts.length;
  }

  double get TotalPrice {
    double total = 0.0;
    _carts.forEach((key, cart) {
      total += cart.amount * cart.price;
    });
    return total;
  }

  void MinusCartAmount(productID, {bool massenger = false}) {
    if (_carts[productID]!.amount != 1) {
      _carts.update(
          productID,
          (nowCart) => cart(
              id: UniqueKey().toString(),
              Title: nowCart.Title,
              photo: nowCart.photo,
              amount: nowCart.amount - 1,
              price: nowCart.price));
    } else if (massenger) {
      _carts.remove(productID);
    }
    notifyListeners();
  }

  void AddCarts(String Title, String Photo, double Price, String ProductID) {
    if (_carts.containsKey(ProductID)) {
      //Sonini ko`paytirish kerak
      _carts.update(
          ProductID,
          (nowCart) => cart(
              id: UniqueKey().toString(),
              Title: nowCart.Title,
              photo: nowCart.photo,
              amount: nowCart.amount + 1,
              price: nowCart.price));
    } else {
      // Agar bulmasam ruyxatga qo`shish kerak
      _carts.putIfAbsent(
          ProductID,
          () => cart(
              id: UniqueKey().toString(),
              Title: Title,
              photo: Photo,
              amount: 1,
              price: Price));
    }
    notifyListeners();
  }

  void DeleteCart(productID) {
    _carts.remove(productID);
    notifyListeners();
  }

  void CleanListByOrder() {
    _carts.clear();
    notifyListeners();
  }
}
