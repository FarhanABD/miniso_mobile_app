// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniso_store/main_screen/category.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/models/wishlist_model.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/product_class.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:miniso_store/widgets/alert_dialog.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

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
            return WishlistModel(product: product);
          },
        );
      },
    );
  }
}
