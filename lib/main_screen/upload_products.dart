import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/snackbar.dart';

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

  void uploadProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Valid');
      print(price);
      print(quantity);
      print(prodName);
      print(prodDesc);
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
                        child: const Center(
                          child: Text(
                            "You Have Not \n \n Picked Image Yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
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
                onPressed: () {},
                backgroundColor: Colors.pinkAccent,
                child: const Icon(Icons.photo_library, color: Colors.white),
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


