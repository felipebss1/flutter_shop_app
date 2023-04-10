import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_shop_app/provider/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterParams = filterByUser
        ? {
            'orderBy': jsonEncode('creatorId'),
            'equalTo': jsonEncode(userId),
          }
        : {};
    var url = Uri.https(
      'shop-app-felipebss-default-rtdb.firebaseio.com',
      '/products.json',
      {
        'auth': authToken,
        ...filterParams,
      },
    );
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      url = Uri.https('shop-app-felipebss-default-rtdb.firebaseio.com',
          '/userFavorites/$userId.json', {'auth': authToken});
      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageURL: value['imageURL'],
            isFavorite: favoriteData?[key] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https('shop-app-felipebss-default-rtdb.firebaseio.com',
        '/products.json', {'auth': authToken});
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageURL,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('shop-app-felipebss-default-rtdb.firebaseio.com',
          '/products/$id.json', {'auth': authToken});
      await http.patch(
        url,
        body: jsonEncode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageURL': newProduct.imageURL,
          'price': newProduct.price,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https('shop-app-felipebss-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': authToken});
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
