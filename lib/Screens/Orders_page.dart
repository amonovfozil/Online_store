import 'package:flutter/material.dart';
import 'package:online_market/models/Order_model.dart';
import 'package:online_market/widgets/Sidebar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) {
      Provider.of<orderIteam>(context, listen: false).GetOrderInFirebase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderIteams = Provider.of<orderIteam>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Byurtmalar'),
        centerTitle: true,
      ),
      drawer: SideBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: orderIteams.lists.isNotEmpty
                  ? ListView.builder(
                      itemCount: orderIteams.lists.length,
                      itemBuilder: ((context, index) {
                        final orders = orderIteams.lists[index];
                        return Card(
                          child: ExpansionTile(
                              title: Text(
                                '\$${orders.totalPrice.toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              subtitle: Text(DateFormat("dd.mm.yyyy hh:mm")
                                  .format(orders.days)),
                              children: orders.cartiteam.map((carts) {
                                return ListTile(
                                  leading: carts.photo.startsWith('assets/')
                                      ? CircleAvatar(
                                          backgroundImage:
                                              AssetImage(carts.photo))
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(carts.photo)),
                                  title: Text(
                                    carts.Title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  trailing: RichText(
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: '${carts.amount}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          TextSpan(text: '  x  '),
                                          TextSpan(
                                            text: '\$${carts.price}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          )
                                        ]),
                                    //   '${orders.cartiteam[index].amount}  x \$${orders.cartiteam[index].price}',
                                    //   style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList()),
                        );
                      }),
                    )
                  : Center(
                      child: Text('Buyurtmalar mavjud emas'),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
