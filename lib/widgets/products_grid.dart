import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, required this.showFavorite}) : super(key: key);
  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorite ? productsData.favoriteItems : productsData.items;
    // print(
    //     " showFavorite = ${showFavorite}  , products = ${products.map((pro) => pro.title).toList()}");
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) {
        // print('products[i] = ${products[i].title}');
        return ChangeNotifierProvider.value(
            value: products[i], child: ProductItem());
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
