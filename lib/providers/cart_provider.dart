//------ CLASS PRODUCT UNTUK MENYIMPAN VALUE DARI SETIAP ----//
//---- PRODUK UNTUK DIMUNCULKAN DI CART SCREEN ---//

import 'package:flutter/foundation.dart';
import 'package:miniso_store/providers/product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    String name,
    double price,
    int qty,
    int stock,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
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

  //----- FUNCTION TAMBAH PRODUK ---------//
  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  //--------- FUNCTION KURANGI PRODUK DI DALAM CART --------//
  void reduceByOne(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
