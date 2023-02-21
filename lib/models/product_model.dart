import 'package:flutter/cupertino.dart';

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

  void isclickFavorite() {
    Isfavorite = !Isfavorite;
    notifyListeners();
  }
}

class ProductList with ChangeNotifier {
  List<Product> _list = [
    Product(
        id: 'p1',
        Title: 'MacBook Pro',
        Descriptions:
            'holati yaxshi , karopka dakument, 85% yomkist, 146 sicly ishlagan, 16/512 Gb SSD, chip:M1',
        url: 'assets/images/mac2.jpg',
        price: 950),
    Product(
        id: 'p2',
        Title: 'IPad',
        Descriptions:
            'holati yaxshi , karopka dakument, 82% yomkist, 1, 8/128 Gb , chip:M',
        url: 'assets/images/ip3.jpg',
        price: 560),
    Product(
        id: 'p3',
        Title: 'IPhone14',
        Descriptions:
            'holati yaxshi , karopka dakument, 95% yomkist, 16/256 Gb, ',
        url: 'assets/images/p.jpg',
        price: 1025),
    Product(
      id: 'p4',
      Title: 'IWatch',
      Descriptions:
          'holati yangi , karopka dakument, , 10 sicly ishlagan, faceId, NTF,Bluethuth',
      url: 'assets/images/iw2.jpg',
      price: 325,
    ),
  ];

  List<Product> get Lists {
    return [..._list];
  }

  void Addproduct(Product _Product) {
    final NewProduct = Product(
        id: 'p${_list.length + 1}',
        Title: _Product.Title,
        Descriptions: _Product.Descriptions,
        url: _Product.url,
        price: _Product.price);
    _list.add(NewProduct);
    notifyListeners();
  }

  Product FindById(String Id) {
    return _list.firstWhere((element) => element.id == Id);
  }

  void UpDateProduct(Product updateProduct) {
    final indexproduct =
        _list.indexWhere((element) => element.id == updateProduct.id);
    _list[indexproduct] = updateProduct;
    notifyListeners();
  }

  List<Product> get Favority {
    return _list.where((element) => element.Isfavorite).toList();
  }

  void DeleteProduct(String ID) {
    _list.removeWhere((element) => element.id == ID);
    notifyListeners();
  }
}
