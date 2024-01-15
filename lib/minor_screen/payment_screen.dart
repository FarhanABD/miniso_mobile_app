import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniso_store/main_screen/dashboard.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customer');

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.00;
    return FutureBuilder<DocumentSnapshot>(
        //--- CHECKING APABILA GUEST DAN USER LOGIN PADA APLIKASI -------//
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.pink.shade100,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.pink.shade100,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.pink.shade100,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(title: 'Payment'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child:
                              //--------- MENAMPILKAN DATA ORDER USER ------------//
                              Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "${totalPaid.toStringAsFixed(2)} USD",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.pinkAccent,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Order',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                //----------------- ROW ONGKIR ---------------//
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shipping Cost',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      ' 10.00' + (' USD '),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                //----- RADIO LISTTILE PAYMENT METHOD --------//
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text('Cash On Delivery'),
                                  subtitle: const Text('Pay Cash At Home'),
                                ),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    title: const Text('Pay Via Mobile Banking'),
                                    subtitle: const Row(
                                      children: [
                                        Icon(
                                          Icons.payment_outlined,
                                          color: Colors.pinkAccent,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Colors.pinkAccent,
                                        )
                                      ],
                                    )),
                                RadioListTile(
                                  value: 3,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text('Pay Via Gopay'),
                                  subtitle: const Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.paypal,
                                        color: Colors.pinkAccent,
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.pinkAccent,
                                      ),
                                    ],
                                  ),
                                )
                                //========== ENDS OF RADIOLISTILE ============//
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                          label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                          onPressed: () {
                            print(selectedValue);
                          },
                          width: 1),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
