import 'package:flutter/material.dart';
import 'package:manga_store/utils/colors.dart';
import 'package:provider/provider.dart';

import '../Provider/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // setstate is not required because initstate runs before widget build...
    // setState(() {
    _isLoading = true;
    // });

    Provider.of<Orders>(context, listen: false).fetchAndSet().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
            ),
    );
  }
}
