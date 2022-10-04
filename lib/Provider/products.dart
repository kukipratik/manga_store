import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:manga_store/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  //variable.....
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'One Piece',
    //   description: 'Best anime of all the time',
    //   price: 29.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/81rEhhwbubL.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Darling in the franxx',
    //   description: 'Anime world with zero two.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/81fkwgB06lL.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Demon Slayer',
    //   description: 'Brother and sister anime',
    //   price: 19.99,
    //   imageUrl:
    //       'https://i.pinimg.com/originals/51/04/03/510403652ec117ff6d1c12ff85731319.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Spy x Family',
    //   description: 'New Trending anime.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/717CIWUQyBL.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  //constructor......
  Products(
    this._items,
    this.authToken,
    this.userId,
  );

  // function for getting item....
  List<Product> get items {
    return [..._items];
  }

  //function for getting favoriate items only...
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //function for finding product using id...
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // function for getting product from server...
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      // print("value['title'] = $value['title']");
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      // print(extractedData);

      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        //this will happen in empty case...
        return;
      }

      url =
          'https://backend-practice-23eef-default-rtdb.firebaseio.com/userFavoriate/$userId.json?auth=$authToken';
      final favoriateResponse = await http.get(Uri.parse(url));
      final favoriateData = json.decode(favoriateResponse.body);

      extractedData.forEach((productId, value) {
        // print("userId= $userId");
        // print("title = ${value['title']} and creator = ${value['creatorId']}");
        loadedProduct.add(Product(
          id: productId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          // isFavorite: value['isFavorite'],
          isFavorite: (favoriateData == null)
              ? false
              : favoriateData[productId] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(product) async {
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products.json?auth=$authToken"';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId": userId,
          }));
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
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
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
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://backend-practice-23eef-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingIndex =
        _items.indexWhere((existingProduct) => existingProduct.id == id);
    var product = _items[existingIndex];

    // deleting product...
    _items.removeWhere((existingProduct) => existingProduct.id == id);
    notifyListeners();

    // if no error setting product back...
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, product);
      notifyListeners();
      throw HttpException("Couldn't Delete this product.");
    }
  }
}
