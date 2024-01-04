// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:miniso_store/main_screen/category.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

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
          appBar: AppBar(
            leading: widget.back,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Consumer<Cart>(
            builder: (context, cart, child) {
              return ListView.builder(
                itemCount: cart.count,
                itemBuilder: (context, index) {
                  return Text(cart.getItems[index].price.toString());
                },
              );
            },
          ),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text(
          //         "Your Cart Is Empty !",
          //         style: TextStyle(fontSize: 30),
          //       ),
          //       const SizedBox(
          //         height: 50,
          //       ),
          //       Material(
          //         color: Colors.pinkAccent.shade100,
          //         borderRadius: BorderRadius.circular(25),
          //         child: MaterialButton(
          //           minWidth: MediaQuery.of(context).size.width * 0.6,
          //           onPressed: () {
          //             //---- VALIDATION OF NAVIGATOR FOR CART SCREEN ---------//
          //             Navigator.canPop(context)
          //                 ? Navigator.pop(context)
          //                 : Navigator.pushReplacementNamed(
          //                     context, '/customer_home');
          //             //===== ENDS OF NAVOGATOR VALIDATION ===================//
          //           },
          //           child: const Text(
          //             "Continue Shopping",
          //             style: TextStyle(fontSize: 18, color: Colors.white),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'Total: \$ ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '00.00',
                      style: TextStyle(
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
