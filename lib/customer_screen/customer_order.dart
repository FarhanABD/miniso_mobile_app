import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class CustomerOrder extends StatelessWidget {
  const CustomerOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Orders',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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
                'You Dont Have Any \n\n Active Order',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.pinkAccent.shade200),
                        borderRadius: BorderRadius.circular(15)),
                    child: ExpansionTile(
                      title: Container(
                        constraints: BoxConstraints(maxHeight: 80),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                constraints: const BoxConstraints(
                                    maxHeight: 80, maxWidth: 80),
                                child: Image.network(order['orderimage']),
                              ),
                            ),
                            Flexible(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order['ordername'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(('\$') +
                                          (order['orderprice']
                                              .toStringAsFixed(2))),
                                      Text(('x ') +
                                          (order['orderqty'].toString())),
                                    ],
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('See More'),
                          Text(order['deliverystatus'])
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
