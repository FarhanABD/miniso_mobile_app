// ignore_for_file: unused_import, unused_local_variable, depend_on_referenced_packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniso_store/utilities/categ_list.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

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
  late String prodId;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];
  bool processing = false;

//--------- FUNCTION IMAGE PICKER -------------------------------------------//
  final ImagePicker picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  List<String> imagesUrlList = [];
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
      print("Error Anjerr");
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

  //-------------- VOID DROPDOWN SELECTED MAIN CATEGORY ----------------------//
  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList == [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }
  //========== ENDS OF VOID DROPDOWN SELECTED MAIN CATEGORY ==================//

  //------------- UPLOAD IMAGES FUNCTION -------------------------------------//
  Future<void> uploadImages() async {
    if (mainCategValue != 'select category' && subCategValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackbar(
              _scaffoldKey, 'Please pick images first');
        }
      } else {
        MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please select category');
    }
  }
  //======================= ENDS OF UPLOAD IMAGES FUNCTION ===================//

  void uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');

      prodId = const Uuid().v4();

      await productRef.doc(prodId).set({
        'prodid': prodId,
        'maincateg': mainCategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'productname': prodName,
        'prodesc': prodDesc,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'proimages': imagesUrlList,
        'discount': 0,
      }).whenComplete(() {
        setState(() {
          processing = false;
          imagesFileList = [];
          mainCategValue = 'select category';
          subCategList = [];
          imagesUrlList = [];
        });
        _formKey.currentState!.reset();
      });
    } else {
      print('no images uploaded');
    }
  }

  //------------------------- VOID FUNGSI UPLOAD PRODUCT ---------------------//
  void uploadProducts() async {
    await uploadImages().whenComplete(() => uploadData());
  }
  //================== ENDS OF VOID FUNGSI UPLOAD PRODUCTS ===================//

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                        color: const Color.fromARGB(255, 250, 165, 193),
                        height: size.width * 0.5,
                        width: size.width * 0.5,
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
                      SizedBox(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "* select main category",
                                  style: TextStyle(color: Colors.pinkAccent),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.pink,
                                  iconDisabledColor: Colors.black,
                                  dropdownColor:
                                      const Color.fromARGB(255, 238, 157, 185),
                                  disabledHint:
                                      const Text('select main category'),
                                  value: mainCategValue,
                                  items: maincateg
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(value),
                                        ),
                                        value: value);
                                  }).toList(),
                                  onChanged: (String? value) {
                                    selectedMainCateg(value);
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "* select sub category",
                                  style: TextStyle(color: Colors.pinkAccent),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.pink,
                                  iconDisabledColor: Colors.black,
                                  dropdownColor:
                                      const Color.fromARGB(255, 238, 157, 185),
                                  menuMaxHeight: 500,
                                  disabledHint:
                                      const Text('select sub category'),
                                  value: subCategValue,
                                  items: subCategList
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(value),
                                        ),
                                        value: value);
                                  }).toList(),
                                  onChanged: (String? value) {
                                    print(value);
                                    setState(() {
                                      subCategValue = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
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
              onPressed: processing == true
                  ? null
                  : () {
                      uploadProducts();
                    },
              backgroundColor: Colors.pinkAccent,
              child: processing == true
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.upload, color: Colors.white),
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
