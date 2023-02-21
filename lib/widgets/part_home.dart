import 'package:flutter/material.dart';
import 'package:online_market/models/product_model.dart';
import 'package:online_market/widgets/product_iteams.dart';
import 'package:provider/provider.dart';

class part_home extends StatelessWidget {
  const part_home({Key? key, required this.isfavorityPage}) : super(key: key);
  final bool isfavorityPage;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductList>(context);
    final Products = isfavorityPage ? productData.Favority : productData.Lists;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
          itemCount: Products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: ((context, index) {
            return ChangeNotifierProvider<Product>.value(
              value: Products[index],
              child: ProductIteams(),
            );
          })),
    );
  }
}
