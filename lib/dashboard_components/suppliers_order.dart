import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class SupplierOrder extends StatelessWidget {
  const SupplierOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Suppliers Orders',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
