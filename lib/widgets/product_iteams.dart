import 'package:flutter/material.dart';
import 'package:online_market/providers/auth.dart';
import 'package:provider/provider.dart';

import '../models/Carts_model.dart';
import '../models/product_model.dart';

class ProductIteams extends StatefulWidget {
  const ProductIteams({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductIteams> createState() => _ProductIteamsState();
}

class _ProductIteamsState extends State<ProductIteams> {
  @override
  Widget build(BuildContext context) {
    final productt = Provider.of<Product>(context);
    final cartIatems = Provider.of<CartIteams>(context);
    final AuthProviderr = Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: (() =>
          Navigator.of(context).pushNamed('InfoProduct', arguments: productt)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Stack(children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: productt.url.startsWith('assets/')
                  ? Image.asset(
                      productt.url,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      productt.url,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: 15,
              right: 0,
              child: Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Center(
                  child: Text(
                    '\$${productt.price.toStringAsFixed(1)}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ]),
          footer: Container(
            height: 60,
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => productt.isclickFavorite(
                        AuthProviderr.Token!, AuthProviderr.UserID!),
                    icon: Icon(
                      productt.Isfavorite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 250,
                    child: Text(
                      productt.Title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartIatems.AddCarts(productt.Title, productt.url,
                          productt.price, productt.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Savatchaga Qo`shish'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'BEKOR QILISH',
                          onPressed: () => cartIatems.MinusCartAmount(
                              productt.id,
                              massenger: true),
                        ),
                      ));
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
