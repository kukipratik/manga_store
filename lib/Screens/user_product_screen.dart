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

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print("build again...");
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
        body: FutureBuilder(
          future: refreshProducts(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: (() => refreshProducts(context)),
                      child: Consumer<Products>(
                        builder: (context, value, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: value.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                  value.items[i].id!,
                                  value.items[i].title!,
                                  value.items[i].imageUrl!,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
