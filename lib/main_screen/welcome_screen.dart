// ignore_for_file: unused_import
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniso_store/main_screen/dashboard.dart';
import 'package:miniso_store/main_screen/supplier_home.dart';
import 'package:miniso_store/widgets/yellow_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//-------- WARNA TEXT PADA ANIMASI HALAMAN LOGIN -----------------------------//
const textColor = [
  Colors.red,
  Colors.pinkAccent,
  Colors.orangeAccent,
  Colors.orange
];
//========== ENDS OF TEXT COLOR ANIMATION WIDGET =============================//

//--------------- ANIMASI TEXTSTYLE PADA HALAMAN LOGIN -----------------------//
const textStyleAnimation =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: 'Acme');
//================== ENDS OF TEXTSTYLE ANIMATION =============================//

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  //-------------- CIRCULAR PROGRESS INDICATOR -------------------------------//
  bool processing = false;

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');

  late String customerId;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/inapp/background.jpg'),
              fit: BoxFit.cover),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //---------- ANIMASI TEXT PADA HALAMAN LOGIN -------------------//
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText("WELCOME",
                      textStyle: textStyleAnimation, colors: textColor),
                  ColorizeAnimatedText("TO MINISO",
                      textStyle: textStyleAnimation, colors: textColor),
                  //========== ENDS OF ANIMATION TEXT IN LOGIN PAGE ==========//
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 10),
              ),
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(
                  image: AssetImage('images/logo/logo_miniso.png'),
                ),
              ),
              const Text(
                "MINISO STORE",
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 150),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Suplliers",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedLogo(controller: controller),
                            YellowButton(
                                label: 'Login',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/supplier_signin");
                                },
                                width: 0.25),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: YellowButton(
                                  label: 'Signup',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, "/supplier_signup");
                                  },
                                  width: 0.25),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: YellowButton(
                              label: 'Login',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "/customer_signin");
                              },
                              width: 0.25),
                        ),
                        YellowButton(
                            label: 'Signup',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/customer_signup");
                            },
                            width: 0.25),
                        AnimatedLogo(controller: controller),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleFacebookLogin(
                        label: 'Google',
                        onPressed: () {},
                        child: const Image(
                          image: AssetImage('images/inapp/google.jpg'),
                        ),
                      ),
                      GoogleFacebookLogin(
                        label: 'Facebook',
                        onPressed: () {},
                        child: const Image(
                          image: AssetImage('images/inapp/facebook.jpg'),
                        ),
                      ),
                      processing == true
                          ? const CircularProgressIndicator()
                          : GoogleFacebookLogin(
                              label: 'Guest',
                              onPressed: () async {
                                setState(() {
                                  processing = true;
                                });
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  customerId =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  await customer.doc(customerId).set({
                                    'name': 'name',
                                    'email': 'email',
                                    'profileimage': 'profileImage',
                                    'phone': '',
                                    'address': '',
                                    'cid': customerId,
                                  });
                                });

                                Navigator.pushReplacementNamed(
                                    context, '/customer_home');
                              },
                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.pinkAccent,
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(
        image: AssetImage('images/inapp/logo.jpg'),
      ),
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogin(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: child,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.pink),
            )
          ],
        ),
      ),
    );
  }
}
