import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/controllers/auth_controller.dart';
import 'package:multi_vender_store_app/firebase_options.dart';
import 'package:multi_vender_store_app/models/buyer_model.dart';
import 'package:multi_vender_store_app/providers/buyer_providers.dart';
import 'package:multi_vender_store_app/providers/cart_provider.dart';
import 'package:multi_vender_store_app/views/buyers/auth/login_screen.dart';
import 'package:multi_vender_store_app/views/buyers/auth/register_screen.dart';
import 'package:multi_vender_store_app/views/buyers/landing_screen.dart';
import 'package:multi_vender_store_app/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BuyerProvider>(
          create: (context) => BuyerProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController.getBuyer(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return Provider(
      create: (BuildContext context) {},
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: GlobalVariables.primaryColor),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Brand-Bold',
        ),
        // home: Provider.of<BuyerProvider>(context).buyer!.buyerId.isEmpty
        //     ? const LoginScreen()
        //     : const MainScreen(),
        home: const MainScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
