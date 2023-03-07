import 'package:flutter/material.dart';
import 'package:online_market/models/product_model.dart';
import 'package:online_market/widgets/product_iteams.dart';
import 'package:provider/provider.dart';

class part_home extends StatefulWidget {
  const part_home({Key? key, required this.isfavorityPage}) : super(key: key);
  final bool isfavorityPage;

  @override
  State<part_home> createState() => _part_homeState();
}

class _part_homeState extends State<part_home> {
  var init = true;
  var _isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) {
      Provider.of<ProductList>(context, listen: false).getProductsInFireBase();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (init) {
      setState(() {
        _isloading = true;
      });
      Provider.of<ProductList>(context).getProductsInFireBase().then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }
    super.didChangeDependencies();
    init = false;
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductList>(context);
    final Products =
        widget.isfavorityPage ? productData.Favority : productData.Lists;
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Products.isNotEmpty
            ? Padding(
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
              )
            : const Center(
                child: Text('Hozircha mahsulot yuq'),
              );
  }
}
