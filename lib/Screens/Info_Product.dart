import 'package:flutter/material.dart';
import 'package:online_market/models/Carts_model.dart';
import 'package:online_market/models/product_model.dart';
import 'package:provider/provider.dart';

class InfoProduct extends StatelessWidget {
  const InfoProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cartsiteam = Provider.of<CartIteams>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.Title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              child: product.url.startsWith('assets/')
                  ? Image.asset(
                      product.url,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      product.url,
                      fit: BoxFit.cover,
                    ),
            ),
            Text(
              'Destcriptions:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Text(
                  product.Descriptions,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
          child: Container(
        height: 70,
        width: double.infinity,
        color: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Narxi:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                  ),
                ],
              ),
              cartsiteam.Carts.containsKey(product.id)
                  ? ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('CartScreen'),
                      icon: Icon(Icons.shop_two_sharp),
                      label: Text(' Xaridlar sahifasi '),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 22)),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => cartsiteam.AddCarts(product.Title,
                          product.url, product.price, product.id),
                      icon: Icon(Icons.add_shopping_cart_sharp),
                      label: Text('Savatchaga Solish'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 22)),
                    )
            ],
          ),
        ),
      )),
    );
  }
}
