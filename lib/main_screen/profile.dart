// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/customer_screen/customer_order.dart';
import 'package:miniso_store/customer_screen/wishlist.dart';
import 'package:miniso_store/main_screen/cart.dart';
import 'package:miniso_store/widgets/alert_dialog.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customer');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      //--- CHECKING APABILA GUEST DAN USER LOGIN PADA APLIKASI -------//
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc(widget.documentId).get()
          : customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: [
              Container(
                height: 230,
                decoration: BoxDecoration(color: Colors.red[300]),
              ),
              CustomScrollView(slivers: [
                SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  expandedHeight: 140,
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        //---- WIDGET UNTUK MENGHILANGKAN TULISAN KETIKA DI SCROLL KEBAWAH----//
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: const Text(
                          "Account",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(color: Colors.red[300]),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 100),
                                child: data['profileimage'] == ''
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            "images/inapp/guest.jpg"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            NetworkImage(data['profileimage'])),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 180),
                                  child: Text(
                                    data['name'] == ''
                                        ? 'guest'.toUpperCase
                                        : data['name'].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //------- CONTAINER PADA HALAMAN PROFILE SCREEN ----------//
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      "Cart",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                                back: AppBarBackButton(),
                                              )));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: const BorderRadius.only(
                                    // topLeft: Radius.circular(30),
                                    // bottomLeft: Radius.circular(30),
                                    ),
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      "Order",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerOrder(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      "Wishlist",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WishlistScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            //================ ENDS OF CONTAINER PROFILE SCREEN ======//
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 150,
                              child: Image(
                                  image: AssetImage(
                                      'images/logo/tulisan_miniso.png')),
                            ),
                            const ProfileHeaderLabel(
                              headerLabel: "  Account Info  ",
                            ),

                            //--- ACCOUNT INFO LIST TILE BUAT EMAIL, PHONE DAN ADDRESS -----//
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      title: "Email Address",
                                      subtitle: data['email'] == ''
                                          ? 'example@gmail.com'
                                          : data['email'],
                                      icon: Icons.email,
                                    ),
                                    PinkDivider(),
                                    RepeatedListTile(
                                      title: data['phone'] == ''
                                          ? '+62000000'
                                          : data['phone'],
                                      subtitle: "+62 xxx xxx",
                                      icon: Icons.phone,
                                    ),
                                    PinkDivider(),
                                    RepeatedListTile(
                                      title: "Address",
                                      subtitle: data['address'] == ''
                                          ? '21 Jump Street'
                                          : data['address'],
                                      icon: Icons.location_pin,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //=================== ENDS OF LIST TILE ========================//

                            //------------------ LIST TILE OF ACCOUNT SETTINGS -------------//
                            const ProfileHeaderLabel(
                                headerLabel: "  Account Settings  "),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      title: 'Edit Profile',
                                      subtitle: '',
                                      icon: Icons.edit,
                                      onPressed: () {},
                                    ),
                                    const PinkDivider(),
                                    RepeatedListTile(
                                      title: 'Change Password',
                                      icon: Icons.lock,
                                      onPressed: () {},
                                    ),
                                    const PinkDivider(),
                                    RepeatedListTile(
                                      title: 'Log Out',
                                      icon: Icons.logout,
                                      onPressed: () async {
                                        MyAlertDialog.showMyDialog(
                                          context: context,
                                          titles: 'Logout',
                                          content:
                                              'Are You Sure Want To Logout?',
                                          tabNo: () {
                                            Navigator.pop(context);
                                          },
                                          tabYes: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                                context, '/welcome_screen');
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //================= ENDS OF ACCOUNT SETTINGS LIST TILE =========//
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ]),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      },
    );
  }
}

class PinkDivider extends StatelessWidget {
  const PinkDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.pink,
        thickness: 1,
      ),
    );
  }
}

//----------- MODAL CLASS OF TITLE, SUBTITLE, ICON AND BUTTON ----------------//

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
      required this.title,
      this.subtitle = "",
      required this.icon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
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
