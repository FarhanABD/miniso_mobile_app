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
