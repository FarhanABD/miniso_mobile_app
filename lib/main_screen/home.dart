import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/galleries/men_gallery.dart';

import 'package:miniso_store/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,

          //------------ CONTAINER SEARCH BAR DI HOME SCREEN -----------------//
          title: FakeSearch(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.redAccent,
            indicatorWeight: 8,
            tabs: [
              RepeatedTab(label: 'Men'),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Shoes'),
              RepeatedTab(label: 'Bags'),
              RepeatedTab(label: 'Electronics'),
              RepeatedTab(label: 'Accesories'),
              RepeatedTab(label: 'Home & Garden'),
              RepeatedTab(label: 'Kids'),
              RepeatedTab(label: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MenGalleryScreen(),
            Center(child: Text('Women Screen')),
            Center(child: Text('Shoes Screen')),
            Center(child: Text('Bags Screen')),
            Center(child: Text('Electronics Screen')),
            Center(child: Text('Accesories Screen')),
            Center(child: Text('Home & Garden Screen')),
            Center(child: Text('Kids Screen')),
            Center(child: Text('Beauty Screen')),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
