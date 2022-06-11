import 'package:flutter/material.dart';
import 'package:manga_store/Provider/products.dart';
import 'package:manga_store/utils/routes.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldSnackbar = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(editProductScreen, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffoldSnackbar.showSnackBar(const SnackBar(
                      content: Text(
                    "Deleting Failed!",
                    textAlign: TextAlign.center,
                  )));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
