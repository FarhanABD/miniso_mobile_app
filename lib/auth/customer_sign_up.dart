// ignore_for_file: duplicate_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/auth_widgets.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
  late String profileImage;
  late String customerId;
  bool processing = false;
  //--------- KEY FOR VALIDATOR MESSAGE OF TEXTFIELD ------------------------//
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  //-------------- BOOLEAN WIDGET FOR VISIBILITY OF PASSWORD -----------------//
  bool passwordVisible = false;

  //---------- FUNCTION TO IMAGE PICKER FROM CAMERA --------------------------//
  final ImagePicker picker = ImagePicker();

  XFile? imageFile;
  dynamic pickedImageError;

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');

  void pickImageFromCamera() async {
    try {
      final pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError);
    }
  }

  //--------- FUNCTION TO PICK IMAGE FROM GALLERY ----------------------------//

  void pickImageFromGallery() async {
    try {
      final pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError);
    }
  }

  //--------------- FUNCTION SIGN UP ----------------------------------------//
  void signUp() async {
    setState(() {
      processing = true;
    });
    if (formkey.currentState!.validate()) {
      if (imageFile != null) {
        //----- TRY BLOCK UNTUK AUTENTIKASI EMAIL USER BARU YG TERDAFTAR --//
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cust-images/$email.jpg');

          await ref.putFile(File(imageFile!.path));
          customerId = FirebaseAuth.instance.currentUser!.uid;

          profileImage = await ref.getDownloadURL();
          await customer.doc(customerId).set({
            'name': name,
            'email': email,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'cid': customerId,
          });
          formkey.currentState!.reset();
          setState(() {
            imageFile = null;
          });

          Navigator.pushReplacementNamed(context, "/customer_signin");
          //Navigator.pushNamed(context, "/customer_signin");
        } on FirebaseAuthException
        //------------ CATCH BLOK UNTUK ERROR MESSAGE EMAIL TERDAFTAR --------//
        catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              processing == false;
            });
            MyMessageHandler.showSnackbar(
                scaffoldKey, "The password is too weak");
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing == false;
            });
            MyMessageHandler.showSnackbar(
                scaffoldKey, "The Email already exist");
          }
        }
      } else {
        setState(() {
          processing == false;
        });
        MyMessageHandler.showSnackbar(scaffoldKey, " Please Pick Image First");
      }
    } else {
      setState(() {
        processing == false;
      });
      MyMessageHandler.showSnackbar(scaffoldKey, " Please fill all fields");
    }
  }
  //======================== ENDS OF SIGN UP FUNCTION ========================//

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: "Sign Up",
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.pink.shade300,
                              backgroundImage: imageFile == null
                                  ? null
                                  : FileImage(
                                      File(imageFile!.path),
                                    ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    pickImageFromCamera();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    pickImageFromGallery();
                                  },
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      //--------- TEXTFIELD FULL NAME SIGN UP PAGE ---------------//
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Fullname";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          // controller: nameController,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Full Name',
                              hintText: 'Enter Your Full Name'),
                        ),
                      ),
                      //============ ENDS OF TEXTFIELD FULL NAME =================//
                      //----------- TEXTFIELD EMAIL ADD SIGN UP PAGE -------------//
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Email";
                            } else if (value.isValidEmail() == false) {
                              return 'Invalid Email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          // controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Email Address',
                              hintText: 'Enter Your Email'),
                        ),
                      ),
                      //============= ENDS OF TEXTFIELD EMAIL ADD ================//
                      //----------- TEXTFIELD PADSSWORD SIGN UP PAGE -------------//
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Password";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          // controller: passwordController,
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              labelText: 'Password',
                              hintText: 'Enter Your Password'),
                        ),
                      ),
                      //============= ENDS OF TEXTFIELD PASSWORD =================//

                      //--------------- HAVEACCOUNT SIGN UP WIDGET ---------------//
                      HaveAccount(
                        haveAccount: "Already Have Account ?",
                        actionLabel: "Log In",
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, 'customer_signin');
                        },
                      ),
                      //---------- REUSABLE SIGN UP BUTTON WIDGET ----------------//
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.pink,
                            )
                          : AuthMainButton(
                              mainButtonLabel: "Sign Up",
                              onPressed: () async {
                                signUp();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
