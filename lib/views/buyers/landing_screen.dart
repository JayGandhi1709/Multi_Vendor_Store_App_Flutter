import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/models/buyer_model.dart';
import 'package:multi_vender_store_app/providers/buyer_providers.dart';
import 'package:multi_vender_store_app/views/buyers/main_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/home_screen.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final buyerProvider = Provider.of<BuyerProvider>(context);
    final CollectionReference buyersStream =
        FirebaseFirestore.instance.collection('buyers');

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: buyersStream.doc(auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            Buyer buyer = Buyer.fromMap(
              snapshot.data!.data()! as Map<String, dynamic>,
            );

            buyerProvider.setBuyerFromModel(buyer);
            // return const VendorRegistationScreen();
            // return const Center(child: CircularProgressIndicator());
          }

          return const MainScreen();
        },
      ),
    
    );
  }
}
