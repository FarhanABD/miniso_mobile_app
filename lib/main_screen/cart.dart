// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniso_store/main_screen/category.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:miniso_store/widgets/alert_dialog.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: widget.back,
            elevation: 0,
            backgroundColor: Colors.pinkAccent.shade100,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          titles: 'Clear Cart',
                          content: 'Are You Sure to clear cart ?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            context.read<Cart>().clearCart();
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
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: \$ ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      context.watch<Cart>().totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                YellowButton(
                  width: 0.45,
                  label: "CHECK OUT",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//------ WDIGET UNTUK MENAMPILKAN TAMPILAN CART SAAT KOSONG ------------------//
class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your Cart Is Empty !",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.pinkAccent.shade100,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                //---- VALIDATION OF NAVIGATOR FOR CART SCREEN ---------//
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
                //===== ENDS OF NAVOGATOR VALIDATION ===================//
              },
              child: const Text(
                "Continue Shopping",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
//============================= ENDS OF EMPTYCART WIDGET =====================//

//------ WIDEGT SAAT DI CART TERDAPAT ITEMS YANG DIPILIH --------------------//
class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            //--- FINAL VARIABLE DARI product -------//
            final product = cart.getItems[index];
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          CupertinoActionSheet(
                                                    title: const Text(
                                                        'Remove Item'),
                                                    message: const Text(
                                                        'Are u sure to remove this item ?'),
                                                    actions: <CupertinoActionSheetAction>[
                                                      CupertinoActionSheetAction(
                                                        isDefaultAction: true,
                                                        onPressed: () async {
                                                          context
                                                                      .read<
                                                                          Wishlist>()
                                                                      .getWishItems
                                                                      .firstWhereOrNull((element) =>
                                                                          element
                                                                              .documentId ==
                                                                          product
                                                                              .documentId) !=
                                                                  null
                                                              ? context
                                                                  .read<Cart>()
                                                                  .removeItem(
                                                                      product)
                                                              : await context
                                                                  .read<
                                                                      Wishlist>()
                                                                  .addWishItem(
                                                                      product
                                                                          .name,
                                                                      product
                                                                          .price,
                                                                      1,
                                                                      product
                                                                          .stock,
                                                                      product
                                                                          .imagesUrl,
                                                                      product
                                                                          .documentId,
                                                                      product
                                                                          .suppId);
                                                          context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Move To Wishlist'),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Delete Item'),
                                                      ),
                                                    ],
                                                    cancelButton: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                                fontSize: 20,
                                                fontFamily: 'Acme'),
                                      ),
                                      IconButton(
                                          onPressed:
                                              product.qty == product.stock
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
          },
        );
      },
    );
  }
}
//========================== ENDS OF CART ITEMS WIDGET =======================//