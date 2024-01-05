//------ CLASS PRODUCT UNTUK MENYIMPAN VALUE DARI SETIAP ----//
//---- PRODUK UNTUK DIMUNCULKAN DI CART SCREEN ---//

import 'package:flutter/foundation.dart';

class Product {
  String name;
  double price;
  int qty = 1;
  int stock;
  List imagesUrl;
  String documentId;
  String suppId;

  Product({
    required this.name,
    required this.price,
    required this.qty,
    required this.stock,
    required this.imagesUrl,
    required this.documentId,
    required this.suppId,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
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
}
