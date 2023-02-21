import 'package:flutter/material.dart';
import 'package:online_market/models/Carts_model.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalCaunt = Provider.of<CartIteams>(context).TotalCaunt;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Stack(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('CartScreen'),
              icon: Icon(
                Icons.add_shopping_cart_sharp,
                size: 25,
              ),
            ),
            Positioned(
              top: 5,
              right: 6,
              child: TotalCaunt > 0
                  ? Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red),
                      child: Center(
                        child: Text(
                          TotalCaunt.toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
