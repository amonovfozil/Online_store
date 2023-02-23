import 'package:flutter/material.dart';
import 'package:online_market/models/product_model.dart';
import 'package:online_market/widgets/Sidebar.dart';
import 'package:provider/provider.dart';

class ManegmentScreen extends StatelessWidget {
  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<ProductList>(context).getProductsInFireBase();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mahsulotlarni boshqarish'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('EditAddScreen'),
              icon: Icon(
                Icons.add_chart_sharp,
                size: 25,
              ),
            ),
          )
        ],
      ),
      drawer: SideBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshPage(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.Lists.length,
          itemBuilder: ((context, index) {
            final product = products.Lists[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: product.url.startsWith('assets/')
                      ? CircleAvatar(
                          backgroundImage: AssetImage(product.url),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(product.url),
                        ),
                  title: Text(
                    product.Title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed('EditAddScreen', arguments: product.id),
                        icon: Icon(
                          Icons.edit,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  titlePadding:
                                      const EdgeInsets.only(left: 40, top: 20),
                                  contentPadding: const EdgeInsets.only(
                                      left: 50, top: 10, bottom: 10),
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: Text('Ishonchingiz komilmi?'),
                                  content: Text('Mahsulotlarni o\`chirishga'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('YUQ'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        products.DeleteProduct(product.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('HA'),
                                    )
                                  ],
                                );
                              }));
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
