import 'package:flutter/material.dart';
import 'package:manga_store/utils/colors.dart';
import 'package:manga_store/utils/routes.dart';
import 'package:manga_store/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

import '../Provider/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appbarColor,
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(editProductScreen);
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                productsData.items[i].id!,
                productsData.items[i].title!,
                productsData.items[i].imageUrl!,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
