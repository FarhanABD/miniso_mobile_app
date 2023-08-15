// ignore_for_file: duplicate_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/auth_widgets.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniso_store/widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
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

  //--------- FUNCTION TO PISK IMAGE FROM GALLERY ----------------------------//

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
                        onPressed: () {},
                      ),
                      //---------- REUSABLE SIGN UP BUTTON WIDGET ----------------//
                      AuthMainButton(
                        mainButtonLabel: "Sign Up",
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            if (imageFile != null) {
                              print("Image Picked");
                              print('Valid');
                              print(name);
                              print(email);
                              print(password);
                              formkey.currentState!.reset();
                              setState(() {
                                imageFile = null;
                              });
                            } else {
                              MyMessageHandler.showSnackbar(
                                  scaffoldKey, " Please Pick Image First");
                            }
                          } else {
                            MyMessageHandler.showSnackbar(
                                scaffoldKey, " Please fill all fields");
                          }
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
