// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:miniso_store/auth/customer_sign_in.dart';
import 'package:miniso_store/auth/customer_sign_up.dart';
import 'package:miniso_store/auth/supplier_sign_in.dart';
import 'package:miniso_store/auth/supplier_sign_up.dart';
import 'package:miniso_store/main_screen/customer_home.dart';
import 'package:miniso_store/main_screen/supplier_home.dart';
import 'package:miniso_store/main_screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miniso_store/providers/cart_provider.dart';
import 'package:miniso_store/providers/stripe_id.dart';
import 'package:miniso_store/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wishlist()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const WelcomeScreen(),
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_signin': (context) => const CustomerLogin(),
        '/supplier_signup': (context) => const SuppliersRegister(),
        '/supplier_signin': (context) => const SuppliersLogin(),
      },
    );
  }
}
