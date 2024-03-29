// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:miniso_store/main_screen/cart.dart';
import 'package:miniso_store/main_screen/visit_store.dart';
import 'package:miniso_store/minor_screen/FullScreenView.dart';
import 'package:miniso_store/models/product_card_model.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  //--- MEMUNCULKAN DATA DARI FIREBASE BERDASARKAN CATEGORY & SUB CATEGORY ----//
  late final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (product) => product.documentId == widget.proList['prodid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imageList: imagesList,
                                  )));
                    },
                    child: Stack(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              //------ MEMANGGIL GAMBAR PRODUK DARI FIREBASE -------//
                              return Image(
                                  image: NetworkImage(imagesList[index]));
                            },
                            itemCount: imagesList.length),
                      ),
                      Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.pinkAccent,
                            child:
                                //--------------- ICON BUTTON BACK ------------------//
                                IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.pinkAccent,
                            child:
                                //---- ICON BUTTON SHARE -----------------------------//
                                IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['productname'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  'USD ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                widget.proList['price'].toStringAsFixed(2),
                                style: onSale != 0
                                    ? const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600)
                                    : const TextStyle(
                                        color: Colors.red,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              onSale != 0
                                  ? Text(
                                      ((1 - (onSale / 100)) *
                                              widget.proList['price'])
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const Text('')
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          var existingItemWishlist = context
                              .read<Wishlist>()
                              .getWishItems
                              .firstWhereOrNull((product) =>
                                  product.documentId ==
                                  widget.proList['prodid']);
                          existingItemWishlist != null
                              ? context
                                  .read<Wishlist>()
                                  .removeWishlist(widget.proList['prodid'])
                              : context.read<Wishlist>().addWishItem(
                                    widget.proList['productname'],
                                    onSale != 0
                                        ? ((1 - (onSale / 100)) *
                                                widget.proList['price'])
                                            .toStringAsFixed(2)
                                        : widget.proList['price'],
                                    1,
                                    widget.proList['instock'],
                                    widget.proList['proimages'],
                                    widget.proList['prodid'],
                                    widget.proList['sid'],
                                  );
                        },
                        icon: context
                                    .watch<Wishlist>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                        product.documentId ==
                                        widget.proList['prodid']) !=
                                null
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                                size: 30,
                              ),
                      ),
                    ],
                  ),
                  widget.proList['instock'] == 0
                      ? const Text('This Item is out of stock')
                      : Text(
                          (widget.proList['instock'].toString()) +
                              (' pieces available in stock'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                  const ProductDetailHeader(
                    label: "   Item Description   ",
                  ),
                  Text(
                    widget.proList['prodesc'],
                    textScaleFactor: 1.1,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade800),
                  ),
                  const ProductDetailHeader(
                    label: "  Similar Items  ",
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        //------- KONDISI JIKA ITEMS PADA CATEGORY TIDAK DITEMUKAN ----------//
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'There is no Items of \n\n Accesories',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        //--------- START OF SCROLLVIEW WIDGET PRODUCTS ----------------------//
                        return SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                return ProductcardModel(
                                  products: snapshot.data!.docs[index],
                                );
                              },
                              staggeredTileBuilder: (context) =>
                                  const StaggeredTile.fit(1)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                        suppId: widget.proList['sid'])));
                          },
                          icon: const Icon(Icons.store)),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                          back: AppBarBackButton(),
                                        )));
                          },
                          icon: badges.Badge(
                              showBadge: context.read<Cart>().getItems.isEmpty
                                  ? false
                                  : true,
                              badgeStyle: const badges.BadgeStyle(
                                  badgeColor: Colors.redAccent),
                              badgeContent: Text(
                                context
                                    .watch<Cart>()
                                    .getItems
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              child: const Icon(Icons.shopping_cart))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: YellowButton(
                      label: existingItemCart != null
                          ? 'added to cart'
                          : 'ADD TO CART',
                      onPressed: () {
                        //--- CHECK APAKAH STOK PRODUK MASIH ADA  --//
                        if (widget.proList['instock'] == 0) {
                          MyMessageHandler.showSnackbar(
                              _scaffoldKey, 'This item is out of stock');
                        } else if (existingItemCart != null) {
                          //--- CHECK APAKAH PRODUK SUDAH TERDAPAT DIDALAM CART --//
                          MyMessageHandler.showSnackbar(
                              _scaffoldKey, 'Your item already in cart');
                        } else {
                          context.read<Cart>().addItem(
                                widget.proList['productname'],
                                onSale != 0
                                    ? ((1 - (onSale / 100)) *
                                            widget.proList['price'])
                                        .toStringAsFixed(2)
                                    : widget.proList['price'],
                                1,
                                widget.proList['instock'],
                                widget.proList['proimages'],
                                widget.proList['prodid'],
                                widget.proList['sid'],
                              );
                        }
                      },
                      width: 0.40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailHeader extends StatelessWidget {
  final String label;
  const ProductDetailHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
            width: 50,
            child: Divider(
              color: Colors.pinkAccent,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                color: Colors.pinkAccent,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
