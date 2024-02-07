import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: CupertinoSearchTextField(
            autofocus: true,
            backgroundColor: Colors.white,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
        ),
        body: searchInput == ""
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.pink.shade200,
                      borderRadius: BorderRadius.circular(25)),
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Search for anything',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final results = snapshot.data!.docs.where((e) =>
                      e['proname'.toLowerCase()]
                          .contains(searchInput.toLowerCase()));
                  return ListView(
                    children: results.map((e) => Text(e['proname'])).toList(),
                  );
                }));
  }
}
