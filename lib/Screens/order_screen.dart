import 'package:flutter/material.dart';
import 'package:manga_store/utils/colors.dart';
import 'package:provider/provider.dart';

import '../Provider/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  // bool _isLoading = false;

  // @override
  // void initState() {
  //   // setstate is not required because initstate runs before widget build...
  //   // setState(() {
  //   _isLoading = true;
  //   // });

  //   Provider.of<Orders>(context, listen: false).fetchAndSet().then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarColor,
        centerTitle: true,
        title: const Text("Your Order"),
      ),
      // body: _isLoading
      // ? const Center(
      //     child: CircularProgressIndicator(),
      //   )
      //     : ListView.builder(
      //         itemCount: orderData.orders.length,
      //         itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
      //       ),

      // FutureBuilder is better approach because unwanted widget rebuild is minimized...
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
        builder: (ctx, dataSnap) {
          if (dataSnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnap.error != null) {
              // have some error
              // then do some error handelling man
              return const Center(child: Text("An error Occured man"));
            } else {
              return Consumer<Orders>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: value.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(order: value.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
