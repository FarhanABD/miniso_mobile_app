import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Static Screen',
        ),
        leading: const AppBarBackButton(),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StaticsModel(label: 'sold out', value: 45),
            StaticsModel(label: 'item count', value: 45),
            StaticsModel(label: 'total balance', value: 45),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class StaticsModel extends StatelessWidget {
  final String label;
  final dynamic value;
  const StaticsModel({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Center(
            child: Text(value.toUpperCase(),
                style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontFamily: 'Acme',
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}
