import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/galleries/accesories_gallery.dart';
import 'package:miniso_store/galleries/bags_gallery.dart';
import 'package:miniso_store/galleries/beauty_gallery.dart';
import 'package:miniso_store/galleries/electronics_gallery.dart';
import 'package:miniso_store/galleries/homegarden_gallery.dart';
import 'package:miniso_store/galleries/kids_gallery.dart';
import 'package:miniso_store/galleries/men_gallery.dart';
import 'package:miniso_store/galleries/shoes_gallery.dart';
import 'package:miniso_store/galleries/women_gallery.dart';

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
        backgroundColor: const Color.fromARGB(255, 249, 231, 237),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,

          //------------ CONTAINER SEARCH BAR DI HOME SCREEN -----------------//
          title: const FakeSearch(),
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
            WomenGalleryScreen(),
            ShoesGalleryScreen(),
            BagsGalleryScreen(),
            ElectronicsGalleryScreen(),
            AccesoriesGalleryScreen(),
            HomeGardenGalleryScreen(),
            KidsGalleryScreen(),
            BeautyGalleryScreen(),
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
