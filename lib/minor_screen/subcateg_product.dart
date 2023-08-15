import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class SubCategProducts extends StatelessWidget {
  final String maincategName;
  final String subcategName;
  const SubCategProducts(
      {Key? key, required this.subcategName, required this.maincategName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subcategName),
      ),
      body: Center(child: Text(maincategName)),
    );
  }
}
