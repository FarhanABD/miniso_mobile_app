// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/main_screen/category.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/minor_screen/place_order.dart';
import 'package:miniso_store/models/cart_model.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/product_class.dart';
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
    double total = context.watch<Cart>().totalPrice;
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
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: total == 0.0
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlaceOrderScreen(),
                                ));
                          },
                  ),
                )
                // YellowButton(
                //   width: 0.45,
                //   label: "CHECK OUT",
                //   onPressed: total == 0.0 ? null : () {},
                // ),
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
            return CartModel(
              product: product,
              cart: context.read<Cart>(),
            );
          },
        );
      },
    );
  }
}
//========================== ENDS OF CART ITEMS WIDGET =======================//