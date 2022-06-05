import 'package:flutter/material.dart';

import '../Provider/cart.dart';

class CItem extends StatelessWidget {
  const CItem({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, i) {
          var valueList = cart.items.values.toList();
          var keyList = cart.items.keys.toList();
          return Dismissible(
            key: ValueKey(valueList[i].id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              cart.removeItem(keyList[i]);
            },
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                    'Do you want to remove the item from the cart?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('\$${valueList[i].price}'),
                    ),
                  ),
                ),
                title: Text(valueList[i].title),
                subtitle: Text(
                    'Total: \$${(valueList[i].price * valueList[i].quantity)}'),
                trailing: Text('${valueList[i].quantity} x'),
              ),
            ),
          );
        });
  }
}
