import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/providers/cart_provider.dart';
import 'package:multi_vender_store_app/views/buyers/inner_screens/edit_profile.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: GlobalVariables.primaryColor,
              title: const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: cartProvider.getCartItems.length,
              itemBuilder: (context, index) {
                var cartItems =
                    cartProvider.getCartItems.values.toList()[index];
                return Card(
                  child: SizedBox(
                    height: 170,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(cartItems.productImages[0]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItems.productName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currencyFormat.format(
                                    cartItems.price * cartItems.quantity),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.primaryColor,
                                ),
                              ),
                              Visibility(
                                visible: true,
                                // visible: cartItems.productSize.isEmpty ? false : true,
                                child: Text(
                                  "Size : ${cartItems.productSize}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomSheet: data['address'] == ''
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Text("Enter Billing Address"))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        EasyLoading.show();

                        cartProvider.getCartItems.forEach((key, item) {
                          final orderId = const Uuid().v4();
                          _firestore.collection("orders").doc(orderId).set({
                            'orderId': orderId,
                            "venderId": item.vendorId,
                            "email": data['email'],
                            "phoneNumber": data['phoneNumber'],
                            "address": data['address'],
                            "buyerId": data['buyerId'],
                            "fullName": data['fullName'],
                            "buyerPhoto": data['profileImage'],
                            "productName": item.productName,
                            "productPrice": item.price,
                            "productId": item.productId,
                            "productImages": item.productImages,
                            "quantity": item.quantity,
                            "productSize": item.productSize,
                            "scheduleDate": item.scheduleDate,
                            "orderDate": DateTime.now(),
                          }).whenComplete(() {
                            cartProvider.clearProvider();
                            EasyLoading.dismiss();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: GlobalVariables.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "${currencyFormat.format(cartProvider.totalPrice)} PLACE ORDER",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: GlobalVariables.primaryColor,
          ),
        );
      },
    );
  }
}
