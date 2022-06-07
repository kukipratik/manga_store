import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_store/utils/routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.transparent),
            accountName: Text(
              "Pratik Lama",
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              "077bct058.pratik@pcampus.edu.np",
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile-pic.png"),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.shop_outlined),
                title: Text(
                  "Shop Now",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(homeScreen);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(CupertinoIcons.cart),
                title: Text(
                  "Cart Page",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(cartScreen);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(CupertinoIcons.money_dollar_circle),
                title: Text(
                  "Your Orders",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(orderScreen);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(
                  'Manage Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(userProductScreen);
                },
              ),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}
