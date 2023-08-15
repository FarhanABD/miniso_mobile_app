import 'package:flutter/material.dart';
import 'package:miniso_store/categories/accesories_categ.dart';
import 'package:miniso_store/categories/bags_categ.dart';
import 'package:miniso_store/categories/beauty_categ.dart';
import 'package:miniso_store/categories/electronic_categ.dart';
import 'package:miniso_store/categories/home_garden_categ.dart';
import 'package:miniso_store/categories/kids_categ.dart';
import 'package:miniso_store/categories/men_categ.dart';
import 'package:miniso_store/categories/shoes_categ.dart';
import 'package:miniso_store/categories/women_categ.dart';
import 'package:miniso_store/widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'Men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'Shoes'),
  ItemsData(label: 'Bags'),
  ItemsData(label: 'Electronics'),
  ItemsData(label: 'Accesories'),
  ItemsData(label: 'Home & Garden'),
  ItemsData(label: 'Kids'),
  ItemsData(label: 'Beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //------- VAR SIZE MEDIAQUERRY BIAR GK PANGGIL PANGGIL -------------------//
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const FakeSearch(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categoryView(size)),
        ],
      ),
    );
  }

//---------- WIDGET SIDE NAVIGATOR HOME SCREEN -------------------------------//
  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceInOut);
              },
              child: Container(
                color: items[index].isSelected == true
                    ? Colors.white
                    : Colors.redAccent.shade100,
                height: 100,
                child: Center(
                  child: Text(
                    items[index].label,
                    style: items[index].isSelected == true
                        ? const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black)
                        : const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            );
          }),
    );
  }

//-------------------- WIDGET CATEGORY VIEW HOME SCREEN ----------------------//
  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          //-- FUNGSI UNTUK DEACTIVATE KATEGORI LAIN YG TIDAK DIPILIH --//
          setState(() {
            for (var element in items) {
              element.isSelected = false;
            }
            setState(() {
              items[value].isSelected = true;
            });
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          BagsCategory(),
          ElectronicCategory(),
          AccessoriesCategory(),
          HomeGardenCategory(),
          KidsCategory(),
          BeautyCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  bool isPilih;
  ItemsData(
      {required this.label, this.isSelected = false, this.isPilih = false});
}
