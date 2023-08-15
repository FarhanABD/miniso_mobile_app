import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class EditStore extends StatelessWidget {
  const EditStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Edit Store',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
