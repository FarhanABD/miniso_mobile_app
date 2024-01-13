//------ WIDEGT SAAT DI CART TERDAPAT ITEMS YANG DIPILIH --------------------//
import 'package:flutter/material.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/product_class.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          child: SizedBox(
        height: 100,
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(product.imagesUrl.first),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<Wishlist>().removeItem(product);
                                },
                                icon: const Icon(Icons.delete_forever)),
                            const SizedBox(
                              width: 10,
                            ),
                            context.watch<Cart>().getItems.firstWhereOrNull(
                                        (element) =>
                                            element.documentId ==
                                            product.documentId) !=
                                    null
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItem(
                                            product.name,
                                            product.price,
                                            1,
                                            product.stock,
                                            product.imagesUrl,
                                            product.documentId,
                                            product.suppId,
                                          );
                                    },
                                    icon: const Icon(Icons.add_shopping_cart)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
//========================== ENDS OF CART ITEMS WIDGET =======================//