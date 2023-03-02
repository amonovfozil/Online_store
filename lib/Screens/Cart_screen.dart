import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:online_market/models/Carts_model.dart';
import 'package:online_market/models/Order_model.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<CartIteams>(context);
    final orderIteams = Provider.of<orderIteam>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Xaridlar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Umumiy:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$${carts.TotalPrice}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    orderButon(orderIteams: orderIteams, carts: carts)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: carts.Carts.length,
                  itemBuilder: ((context, index) {
                    final cart = carts.Carts.values.toList()[index];
                    final cartID = carts.Carts.keys.toList()[index];
                    var networkImage = NetworkImage(cart.photo);
                    return Slidable(
                      key: ValueKey(cartID),
                      endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          extentRatio: 0.3,
                          children: [
                            ElevatedButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      titlePadding: const EdgeInsets.only(
                                          left: 40, top: 20),
                                      contentPadding: const EdgeInsets.only(
                                          left: 50, top: 10, bottom: 10),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      title: Text('Ishonchingiz komilmi?'),
                                      content:
                                          Text('Xaridlaringizni o\`chirishga'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('YUQ'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print(carts.Carts);
                                            carts.DeleteCart(cartID);
                                            Navigator.of(context).pop();
                                            print(carts.Carts);
                                          },
                                          child: Text('HA'),
                                        )
                                      ],
                                    );
                                  })),
                              child: Text(
                                'Delete',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26, vertical: 28),
                                  backgroundColor:
                                      Theme.of(context).errorColor),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Card(
                          child: ListTile(
                            leading: cart.photo.startsWith('assets')
                                ? CircleAvatar(
                                    backgroundImage: AssetImage(cart.photo))
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(cart.photo)),
                            title: Text(
                              cart.Title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                                'Umumiy: \$${(cart.amount * cart.price).toStringAsFixed(1)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      carts.MinusCartAmount(cartID),
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                  splashRadius: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    cart.amount.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => carts.AddCarts(cart.Title,
                                      cart.photo, cart.price, cartID),
                                  icon: Icon(Icons.add),
                                  splashRadius: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })))
        ],
      ),
    );
  }
}

class orderButon extends StatefulWidget {
  const orderButon({
    Key? key,
    required this.orderIteams,
    required this.carts,
  }) : super(key: key);

  final orderIteam orderIteams;
  final CartIteams carts;

  @override
  State<orderButon> createState() => _orderButonState();
}

class _orderButonState extends State<orderButon> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.carts.Carts.isEmpty || _isloading == true)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await widget.orderIteams.addOrder(
                  widget.carts.TotalPrice, widget.carts.Carts.values.toList());
              setState(() {
                _isloading = false;
              });
              widget.carts.CleanListByOrder();
              Navigator.of(context).pushReplacementNamed('Byurtmalar');
            },
      child: _isloading
          ? Container(height: 20, width: 20, child: CircularProgressIndicator())
          : Text('BYURTMA BERISH'),
    );
  }
}
