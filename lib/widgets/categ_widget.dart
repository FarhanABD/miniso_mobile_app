import 'package:flutter/material.dart';
import 'package:miniso_store/minor_screen/subcateg_product.dart';

class SliderBar extends StatelessWidget {
  final String mainCategName;
  const SliderBar({Key? key, required this.mainCategName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCategName == 'beauty'
                    ? const Text("")
                    : const Text(" << ", style: style),
                Text(mainCategName.toUpperCase(), style: style),
                mainCategName == 'men'
                    ? const Text("")
                    : const Text(
                        " >> ",
                        style: style,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 10);

class SubCategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subCategLabel;

  const SubCategModel(
      {Key? key,
      required this.assetName,
      required this.mainCategName,
      required this.subCategLabel,
      required this.subCategName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategProducts(
                      maincategName: mainCategName,
                      subcategName: subCategName,
                    )));
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: 60,
              child: Image(
                image: AssetImage(assetName),
              ),
            ),
            Text(
              subCategLabel,
              style: const TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
