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
          title: 'Customer Order',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
