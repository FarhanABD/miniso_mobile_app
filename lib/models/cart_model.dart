import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/product_class.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

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
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              //------ ICON (-) & (+) ----------//
                              product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        //----- CUPERTINO POP UP WIDGET --------//
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                            title: const Text('Remove Item'),
                                            message: const Text(
                                                'Are u sure to remove this item ?'),
                                            actions: <CupertinoActionSheetAction>[
                                              CupertinoActionSheetAction(
                                                isDefaultAction: true,
                                                onPressed: () async {
                                                  context
                                                              .read<Wishlist>()
                                                              .getWishItems
                                                              .firstWhereOrNull(
                                                                  (element) =>
                                                                      element
                                                                          .documentId ==
                                                                      product
                                                                          .documentId) !=
                                                          null
                                                      ? context
                                                          .read<Cart>()
                                                          .removeItem(product)
                                                      : await context
                                                          .read<Wishlist>()
                                                          .addWishItem(
                                                              product.name,
                                                              product.price,
                                                              1,
                                                              product.stock,
                                                              product.imagesUrl,
                                                              product
                                                                  .documentId,
                                                              product.suppId);
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    'Move To Wishlist'),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text('Delete Item'),
                                              ),
                                            ],
                                            cancelButton: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'cancel',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20),
                                                )),
                                          ),
                                        );
                                        //======== ENDS OF CUPERTINO POP UP WIDGET =======//
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 18,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        cart.reduceByOne(product);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.minus,
                                        size: 18,
                                      )),
                              //--- ICON TEXT QUANTITY -----//
                              Text(
                                product.qty.toString(),
                                style: product.qty == product.stock
                                    ? const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Acme',
                                        color: Colors.red)
                                    : const TextStyle(
                                        fontSize: 20, fontFamily: 'Acme'),
                              ),
                              IconButton(
                                  onPressed: product.qty == product.stock
                                      ? null
                                      : () {
                                          cart.increment(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  ))
                              //====== ENDS OF ICON (-) & (+) ====//
                            ],
                          ),
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
