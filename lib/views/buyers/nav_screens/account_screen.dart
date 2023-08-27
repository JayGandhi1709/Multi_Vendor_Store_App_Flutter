import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/controllers/auth_controller.dart';
import 'package:multi_vender_store_app/models/buyer_model.dart';
import 'package:multi_vender_store_app/providers/buyer_providers.dart';
import 'package:multi_vender_store_app/utils/show_snackBar.dart';
import 'package:multi_vender_store_app/views/buyers/auth/login_screen.dart';
import 'package:multi_vender_store_app/views/buyers/inner_screens/edit_profile.dart';
import 'package:multi_vender_store_app/views/buyers/inner_screens/order_screen.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    BuyerProvider buyerProvider = Provider.of<BuyerProvider>(context);
    var buyer = buyerProvider.buyer!;

    @override
    void dispose() {
      buyerProvider.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.moon_fill,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: buyer.buyerId.isEmpty
            ? Column(

                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: GlobalVariables.primaryColor,
                      child: const Icon(Icons.person,size: 50,color: Colors.white,),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Login Account To Access Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 300,
                      decoration: BoxDecoration(
                        color: GlobalVariables.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: GlobalVariables.primaryColor,
                      child: Image.network(buyer.profileImage),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      buyer.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      buyer.email,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 300,
                      decoration: BoxDecoration(
                        color: GlobalVariables.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Phone"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.add_shopping_cart_rounded),
                    title: Text("Cart"),
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.cube_box_fill),
                    title: const Text("Orders"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                      // buyerProvider.clearProvider();
                      showSnackBar(context, "Logout Successfully!");
                      await AuthController().signOut();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
