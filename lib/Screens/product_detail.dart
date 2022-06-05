import 'package:flutter/material.dart';
import 'package:manga_store/Provider/products.dart';
import 'package:manga_store/utils/colors.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: appbarColor,
        title: Text(loadedProduct.title!),
      ),
    );
  }
}
