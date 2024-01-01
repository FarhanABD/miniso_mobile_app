import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/appbar_widget.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imageList;
  const FullScreenView({Key? key, required this.imageList}) : super(key: key);

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: Column(
        children: [
          const Center(
              child: Text(
            '1/5',
            style: TextStyle(fontSize: 24, letterSpacing: 8),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView(
              children: List.generate(widget.imageList.length, (index) {
                return InteractiveViewer(
                    transformationController: TransformationController(),
                    child: Image.network(widget.imageList[index].toString()));
              }),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageList.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.all(8),
                      width: 120,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 4, color: Colors.pinkAccent),
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageList[index],
                          fit: BoxFit.cover,
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
