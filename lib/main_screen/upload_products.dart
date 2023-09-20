// ignore_for_file: unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniso_store/widgets/snackbar.dart';

List<String> categ = [
  'select category',
  'men',
  'women',
  'shoes',
  'bags',
];

List<String> categMen = [
  'subcategory',
  'shirt',
  'jacket',
  'shoes',
  'jeans',
];

List<String> categWomen = [
  'subcategory'
      'w shirt',
  'w jacket',
  'w shoes',
  'w jeans',
];

List<String> categShoes = [
  'subcategory',
  's shirt',
  's jacket',
  's shoes',
  's jeans',
];

List<String> categBags = [
  'subcategory',
  'B shirt',
  'B jacket',
  'B shoes',
  'B jeans',
];

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

//------- VARIABLES FOR EACH TEXTFIELD --------------------------------------//
  late double price;
  late int quantity;
  late String prodName;
  late String prodDesc;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];

//--------- FUNCTION IMAGE PICKER -------------------------------------------//
  final ImagePicker picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  dynamic pickedImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError);
    }
  }

//-------------- WIDGET UNTUK PREVIEW IMAGES ITEMS -------------------------//
  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
        itemCount: imagesFileList!.length,
        itemBuilder: (context, index) {
          return Image.file(File(imagesFileList![index].path));
        },
      );
    } else {
      return const Center(
        child: Text(
          "You Have Not \n \n Picked Image Yet",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
  //=============== ENDS OF WIDGET PREVIEW IMAGES ============================//

  void uploadProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        print('images picked');
        print('Valid');
        print(price);
        print(quantity);
        print(prodName);
        print(prodDesc);
        setState(() {
          imagesFileList = [];
        });
        _formKey.currentState!.reset();
      } else {
        MyMessageHandler.showSnackbar(_scaffoldKey, 'Please pick images first');
      }
    } else {
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.blueGrey.shade100,
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: imagesFileList != null
                            ? previewImages()
                            : const Center(
                                child: Text(
                                  "You Have Not \n \n Picked Image Yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                      //------------ COLUMN DROPDOWN CATEGORY ----------------//
                      Column(
                        children: [
                          const Text("select main category"),
                          DropdownButton(
                            value: mainCategValue,
                            items: categ.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                  child: Text(value), value: value);
                            }).toList(),
                            onChanged: (String? value) {
                              if (value == 'men') {
                                setState(() {
                                  subCategValue = 'shirt';
                                });
                                subCategList = categMen;
                              } else if (value == 'women') {
                                setState(() {
                                  subCategValue = 'w shirt';
                                });
                                subCategList = categWomen;
                              }
                              print(value);
                              setState(() {
                                mainCategValue = value!;
                                subCategValue = 'subcategory';
                              });
                            },
                          ),
                          const Text("select sub category"),
                          DropdownButton(
                            value: subCategValue,
                            items: subCategList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                  child: Text(value), value: value);
                            }).toList(),
                            onChanged: (String? value) {
                              print(value);
                              setState(() {
                                subCategValue = value!;
                              });
                            },
                          )
                        ],
                      )
                      //=========== ENDS OF COLUMN DROPDOWN CATEGORY =========//
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(color: Colors.pink, thickness: 1.5),
                  ),

                  //------------- TEXT FORM FIELD PRICE WIDGET ------------------//
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Price';
                            } else if (value.isValidPrice() != true) {
                              return "Invalid Price";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: textFormDecoration.copyWith(
                            labelText: "price",
                            hintText: "price..\$",
                          )),
                    ),
                  ),
                  //================ ENDS OF TEXTFORM FIELD PRICE WIDGET =========//
                  //------------- TEXT FORM FIELD QUANTITY WIDGET ----------------//
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Qty';
                            } else if (value.isValidQuantity() != true) {
                              return 'Not Valid Quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Quantity",
                            hintText: "Add Quantity",
                          )),
                    ),
                  ),
                  //============= ENDS OF TEXTFORM FIELD QUANTITY WIDGET =========//
                  //------------- TEXT FORM FIELD PROD NAME WIDGET ---------------//
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Product Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            prodName = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Product Name",
                            hintText: "Enter Product Name",
                          )),
                    ),
                  ),
                  //============ ENDS OF TEXTFORM FIELD PROD NAME WIDGET =========//
                  //------------- TEXT FORM FIELD PROD DESC WIDGET ---------------//
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Product Description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            prodDesc = value!;
                          },
                          maxLength: 800,
                          maxLines: 5,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Product Description",
                            hintText: "Enter Product Description",
                          )),
                    ),
                  ),
                  //============ ENDS OF TEXTFORM FIELD PROD DESC WIDGET =========//
                ],
              ),
            ),
          ),
        ),
        //------------------- 2 WIDGET FLOATING ACTIONS BUTTON -----------------//
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imagesFileList!.isEmpty
                    ? () {
                        pickProductImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                //---- FUNGSI PENGECEKAN UNTUK MEMPROSES ICONS JIKA USER MENEKAN
                // ICON HAPUS IMAGE ------------------------------------------//
                backgroundColor: Colors.pinkAccent,
                child: imagesFileList!.isEmpty
                    ? const Icon(Icons.photo_library, color: Colors.white)
                    : const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                uploadProduct();
              },
              backgroundColor: Colors.pinkAccent,
              child: const Icon(Icons.upload, color: Colors.white),
            ),
          ],
        ),
        //================== ENDS OF FLOATING ACTION BUTTON ====================//
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: "price",
  hintText: "price..\$",
  labelStyle: const TextStyle(color: Colors.pink),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink.shade300, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10)),
);

//------ REGULAR EXPRESSION VALIDATOR QTY PRODUCT ---------------------------//
extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}
//================= ENDS OF REGULAR EXPRESSION VALIDATOR QTY PRODUCT =========//

//------ REGULAR EXPRESSION VALIDATOR PRICE PRODUCT --------------------------//
extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
//=============== ENDS OF REGULAR EXPRESSION VALIDATOR PRICE PRODUCT =========//
