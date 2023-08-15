import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Suppliers Balance',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
