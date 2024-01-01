// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:miniso_store/models/product_card_model.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<dynamic> imagesList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'])
        .where('subcateg', isEqualTo: widget.proList['subcateg'])
        .snapshots();

    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Swiper(
                        pagination: const SwiperPagination(
                            builder: SwiperPagination.fraction),
                        itemBuilder: (context, index) {
                          //------ MEMANGGIL GAMBAR PRODUK DARI FIREBASE -------//
                          return Image(image: NetworkImage(imagesList[index]));
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
                        const Text(
                          '   USD ',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.proList['price'].toStringAsFixed(2),
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.red,
                          size: 30,
                        )),
                  ],
                ),
                Text(
                  (widget.proList['instock'].toString()) +
                      (' pieces available in stock'),
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
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

                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.store)),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: YellowButton(
                    label: 'ADD TO CART', onPressed: () {}, width: 0.40),
              ),
            ],
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
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
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
