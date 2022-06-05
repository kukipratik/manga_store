import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_store/Provider/cart.dart';
import 'package:manga_store/utils/routes.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../widgets/my_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    // print("build again boro hahaha");

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: appbarColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Store",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              badgeColor: Colors.white,
              position: BadgePosition.topEnd(top: 3, end: 6),
              badgeContent: Text(cart.itemCount.toString()),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(cartScreen);
                  },
                  icon: const Icon(
                    CupertinoIcons.cart,
                    size: 30,
                  )),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(showFavorite: _showOnlyFavorites),
    );
  }
}
