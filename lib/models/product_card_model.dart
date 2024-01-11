import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/minor_screen/ProductDetail.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductcardModel extends StatefulWidget {
  final dynamic products;
  const ProductcardModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductcardModel> createState() => _ProductcardModelState();
}

class _ProductcardModelState extends State<ProductcardModel> {
  late var existingItemWishlist = context
      .read<Wishlist>()
      .getWishItems
      .firstWhereOrNull(
          (product) => product.documentId == widget.products['prodid']);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      proList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Container(
                    constraints: const BoxConstraints(
                        maxHeight: 250,
                        minHeight: 100,
                        maxWidth: 250,
                        minWidth: 100),
                    child: Image(
                        image: NetworkImage(widget.products['proimages'][0])),
                  ),
                ),
              ),
              //---- WIDGET TEXT UNTUK MENAMPILKAN NAMA PRODUCT ----//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      widget.products['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    //----- ROW WIDGET UNTUK MENAMPILKAN HARGA PRODUCT ---//
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products['price'].toStringAsFixed(2) + (' \$'),
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        widget.products['sid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ))
                            : IconButton(
                                onPressed: () {
                                  existingItemWishlist != null
                                      ? context
                                          .watch<Wishlist>()
                                          .removeWishlist(
                                              widget.products['prodid'])
                                      : context.read<Wishlist>().addWishItem(
                                            widget.products['productname'],
                                            widget.products['price'],
                                            1,
                                            widget.products['instock'],
                                            widget.products['proimages'],
                                            widget.products['prodid'],
                                            widget.products['sid'],
                                          );
                                },
                                icon: context
                                            .read<Wishlist>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['prodid']) !=
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
