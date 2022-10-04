import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavorite;

  //constructor...
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  //
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    bool oldStatus = isFavorite;

    //this is for mobile ui....
    isFavorite = !isFavorite;
    notifyListeners();

    //and this block is for web server... (Note:- error is thrown for only post and get.)
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/userFavoriate/$userId/$id.json?auth=$token';
    try {
      var response = await http.put(Uri.parse(url),
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        //will be helpful if any error occurs in server side...
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      //this catch will be helpful when no network...
      isFavorite = oldStatus;
      notifyListeners();
    }

    // print(response.body);
  }
}
