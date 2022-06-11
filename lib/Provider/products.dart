import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'One Piece',
      description: 'Best anime of all the time',
      price: 29.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/81rEhhwbubL.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Darling in the franxx',
      description: 'Anime world with zero two.',
      price: 59.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/81fkwgB06lL.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Demon Slayer',
      description: 'Brother and sister anime',
      price: 19.99,
      imageUrl:
          'https://i.pinimg.com/originals/51/04/03/510403652ec117ff6d1c12ff85731319.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Spy x Family',
      description: 'New Trending anime.',
      price: 49.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/717CIWUQyBL.jpg',
    ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    // notifyListeners();
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProduct() async {
    const url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite']));
      });
      // print(json.decode(response.body));
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(product) async {
    const url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite
          }));
      // print(json.decode(response.body));
      _items.add(Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, product) async {
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products/$id.json';
    var gotThisIndex =
        _items.indexWhere((existingProduct) => existingProduct.id == id);
    if (gotThisIndex >= 0) {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl
          }));
      _items[gotThisIndex] = Product(
          id: id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      // print("replaced");
      notifyListeners();
    } else {
      // print("noting bro");
      return;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((existingProduct) => existingProduct.id == id);
    notifyListeners();
  }
}
