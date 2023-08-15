import 'package:flutter/material.dart';
import 'package:miniso_store/dashboard_components/edit_store.dart';
import 'package:miniso_store/dashboard_components/manage_product.dart';
import 'package:miniso_store/dashboard_components/my_store.dart';
import 'package:miniso_store/dashboard_components/suppliers_balance.dart';
import 'package:miniso_store/dashboard_components/suppliers_order.dart';
import 'package:miniso_store/dashboard_components/suppliers_statics.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

//---------- LIST LABEL PADA HALAMAN DASHBOARD SUPPLIERS -------//
List<String> label = [
  'My Store',
  'Orders',
  'Edit Profile',
  'Manage Products',
  'Balance',
  'Statics',
];

//---------- LIST ICONS PADA HALAMAN DASHBOARD SUPPLIERS -------//
List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

//------ LIST WIDGET UNTUK MEMANGGIL HALAMAN - HALAMAN LAIN PADA DASHBOARD ---//
List<Widget> pages = const [
  MyStore(),
  SupplierOrder(),
  EditStore(),
  ManageProduct(),
  BalanceScreen(),
  StaticsScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/welcome_screen');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pages[index],
                  ),
                );
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.pinkAccent.shade200,
                color: Colors.pink.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 50,
                      color: Colors.yellowAccent,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          fontFamily: 'Acme'),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
