import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/models/product_card_model.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Manage Products',
        ),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
        },
      ),
    );
  }
}
