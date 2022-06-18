import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedItem = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      //will be helpful if there is no any orders...
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedItem.add(OrderItem(
        orderId,
        orderData['amount'],
        (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  item['id'],
                  item['title'],
                  item['quantity'],
                  item['price'],
                ))
            .toList(),
        DateTime.parse(orderData['dateTime']),
      ));
    });

    _orders = loadedItem.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        json.decode(response.body)['name'],
        total,
        cartProducts,
        timeStamp,
      ),
    );
    notifyListeners();
  }
}
