// ignore_for_file: duplicate_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/widgets/auth_widgets.dart';
import 'package:miniso_store/widgets/snackbar.dart';
import 'package:miniso_store/widgets/snackbar.dart';

class SuppliersLogin extends StatefulWidget {
  const SuppliersLogin({Key? key}) : super(key: key);

  @override
  State<SuppliersLogin> createState() => _SuppliersLoginState();
}

class _SuppliersLoginState extends State<SuppliersLogin> {
  late String email;
  late String password;

  bool processing = false;
  //--------- KEY FOR VALIDATOR MESSAGE OF TEXTFIELD ------------------------//
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  //-------------- BOOLEAN WIDGET FOR VISIBILITY OF PASSWORD -----------------//
  bool passwordVisible = false;

  //--------------- FUNCTION SIGN UP ----------------------------------------//
  void Login() async {
    // setState(() {
    //   processing = true;
    // });
    if (formkey.currentState!.validate()) {
      //----- TRY BLOCK UNTUK AUTENTIKASI EMAIL USER BARU YG TERDAFTAR --//
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        formkey.currentState!.reset();

        Navigator.pushReplacementNamed(context, '/supplier_home');
      } on FirebaseAuthException
      //------------ CATCH BLOK UNTUK ERROR MESSAGE EMAIL TERDAFTAR --------//
      catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing == false;
          });
          MyMessageHandler.showSnackbar(
              scaffoldKey, 'No user found for that Email');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing == false;
          });
          MyMessageHandler.showSnackbar(
              scaffoldKey, 'Wrong Password for that Email');
        }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: "Sign In",
                      ),
                      const SizedBox(
                        height: 50,
                      ),
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
                                  passwordVisible == false
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              labelText: 'Password',
                              hintText: 'Enter Your Password'),
                        ),
                      ),

                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      //============= ENDS OF TEXTFIELD PASSWORD =================//

                      //--------------- HAVEACCOUNT SIGN UP WIDGET ---------------//
                      HaveAccount(
                        haveAccount: "Dont Have Account? ",
                        actionLabel: "Sign Up",
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_signup');
                        },
                      ),
                      //---------- REUSABLE SIGN UP BUTTON WIDGET ----------------//
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.pink,
                            ))
                          : AuthMainButton(
                              mainButtonLabel: "Login",
                              onPressed: () async {
                                Login();
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
