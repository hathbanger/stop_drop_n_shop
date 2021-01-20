import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stop_drop_n_shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteState() async {
    final url =
        'https://stopdropnshop-55c7d-default-rtdb.firebaseio.com/products/$id.json';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.patch(
      url,
      body: json.encode(
        {
          'isFavorite': isFavorite,
        },
      ),
    );
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException("Favorite didn't work.");
    }
  }
}
