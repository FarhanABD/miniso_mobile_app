//------ CLASS PRODUCT UNTUK MENYIMPAN VALUE DARI SETIAP ----//
//---- PRODUK UNTUK DIMUNCULKAN DI CART SCREEN ---//

import 'package:flutter/foundation.dart';
import 'package:miniso_store/providers/product_class.dart';

class Wishlist extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int qty,
    int stock,
    List imagesUrl,
    String documentId,
    String suppId,
  ) async {
    final product = Product(
        name: name,
        price: price,
        qty: qty,
        stock: stock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }

  void removeWishlist(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
