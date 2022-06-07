import 'package:flutter/material.dart';
import 'package:manga_store/utils/colors.dart';
import 'package:provider/provider.dart';

import '../Provider/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarColor,
        centerTitle: true,
        title: const Text("Your Order"),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
      ),
    );
  }
}
