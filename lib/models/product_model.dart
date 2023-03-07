import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String Title;
  final String Descriptions;
  final double price;
  final String url;
  bool Isfavorite = false;

  Product({
    required this.id,
    required this.Title,
    required this.Descriptions,
    required this.url,
    required this.price,
    this.Isfavorite = false,
  });

  Future<void> isclickFavorite(String token, String userID) async {
    final oldIs = Isfavorite;
    Isfavorite = !Isfavorite;
    final url = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/userFavority/$userID/$id.json?auth=$token');
    try {
      http.put(
        url,
        body: jsonEncode(Isfavorite),
      );
    } catch (error) {}
    notifyListeners();
  }
}

class ProductList with ChangeNotifier {
  List<Product> _list = [];

  List<Product> get Lists {
    return [..._list];
  }

  String? _token;
  String? userID;

  void getAuthToken(String? token, String? USERID) {
    _token = token;
    userID = USERID;
  }

  Future<void> getProductsInFireBase([bool filter = false]) async {
    print(filter);
    var filterString = filter ? 'orderBy="createrID"&equalTo="$userID"' : '';
    Uri url = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/products.json?auth=$_token&$filterString');
    final urlfavority = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/userFavority/$userID.json?auth=$_token');

    try {
      final respons = await http.get(url);
      final favorityrespons = await http.get(urlfavority);
      if (jsonDecode(respons.body) != null) {
        final DataBase = jsonDecode(respons.body) as Map<String, dynamic>;
        final DataFavority = jsonDecode(favorityrespons.body);

        final List<Product> insertProducts = [];
        DataBase.forEach((productId, products) {
          insertProducts.add(
            Product(
              id: productId,
              Title: products['title'],
              Descriptions: products['Descriptions'],
              url: products['url'],
              price: products['price'],
              Isfavorite: DataFavority == false
                  ? true
                  : DataFavority[productId] ?? false,
            ),
          );
          _list = insertProducts;

          notifyListeners();
        });
      }
    } catch (error) {
      return;
    }
  }

  Future<void> Addproduct(Product _Product) async {
    final url = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/products.json?auth=$_token');
    try {
      final Javob = await http.post(url,
          body: jsonEncode({
            "title": _Product.Title,
            "Descriptions": _Product.Descriptions,
            "url": _Product.url,
            "price": _Product.price,
            'createrID': userID,
          }));

      final javonID = (jsonDecode(Javob.body) as Map<String, dynamic>)['name'];

      final NewProduct = Product(
          id: javonID,
          Title: _Product.Title,
          Descriptions: _Product.Descriptions,
          url: _Product.url,
          price: _Product.price);
      _list.add(NewProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product FindById(String Id) {
    return _list.firstWhere((element) => element.id == Id);
  }

  Future<void> UpDateProduct(Product updateProduct) async {
    final indexproduct =
        _list.indexWhere((element) => element.id == updateProduct.id);
    final url = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/products/${updateProduct.id}.json?auth=$_token');
    try {
      await http.patch(
        url,
        body: jsonEncode(
          {
            "title": updateProduct.Title,
            "Descriptions": updateProduct.Descriptions,
            "url": updateProduct.url,
            "price": updateProduct.price,
          },
        ),
      );
      _list[indexproduct] = updateProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get Favority {
    return _list.where((element) => element.Isfavorite).toList();
  }

  Future<void> DeleteProduct(String ID) async {
    final Url = Uri.parse(
        'https://onlinestrore-1cd2a-default-rtdb.firebaseio.com/products/$ID.json?auth=$_token');
    try {
      await http.delete(Url);
      _list.removeWhere((element) => element.id == ID);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
