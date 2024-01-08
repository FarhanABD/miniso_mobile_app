// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniso_store/main_screen/category.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:miniso_store/widgets/alert_dialog.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: const AppBarBackButton(),
            elevation: 0,
            backgroundColor: Colors.pinkAccent.shade100,
            title: const AppBarTitle(title: 'Wishlist'),
            actions: [
              context.watch<Wishlist>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          titles: 'Clear Wishlist',
                          content: 'Are You Sure to clear wishlist ?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            context.read<Wishlist>().clearWishlist();
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
          body: context.watch<Wishlist>().getWishItems.isNotEmpty
              ? const WishlistItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

//------ WDIGET UNTUK MENAMPILKAN TAMPILAN CART SAAT KOSONG ------------------//
class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Wishlist Is Empty !",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
//============================= ENDS OF EMPTYCART WIDGET =====================//

//------ WIDEGT SAAT DI CART TERDAPAT ITEMS YANG DIPILIH --------------------//
class WishlistItems extends StatelessWidget {
  const WishlistItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wishlist>(
      builder: (context, wishlist, child) {
        return ListView.builder(
          itemCount: wishlist.count,
          itemBuilder: (context, index) {
            //--- FINAL VARIABLE DARI product -------//
            final product = wishlist.getWishItems[index];
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
                                          context
                                              .read<Wishlist>()
                                              .removeItem(product);
                                        },
                                        icon: const Icon(Icons.delete_forever)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    context
                                                .watch<Cart>()
                                                .getItems
                                                .firstWhereOrNull((element) =>
                                                    element.documentId ==
                                                    product.documentId) !=
                                            null
                                        ? const SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              // context
                                              //             .read<Cart>()
                                              //             .getItems
                                              //             .firstWhereOrNull((element) =>
                                              //                 element
                                              //                     .documentId ==
                                              //                 product
                                              //                     .documentId) !=
                                              //         null
                                              //     ? print('in cart')
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
                                            icon: const Icon(
                                                Icons.add_shopping_cart)),
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
          },
        );
      },
    );
  }
}
//========================== ENDS OF CART ITEMS WIDGET =======================//