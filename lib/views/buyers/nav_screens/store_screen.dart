import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/views/buyers/productDetail/store_detail_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: GlobalVariables.primaryColor,
          ));
        }

        return SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) {
              final storeData = snapshot.data!.docs[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreDetailScreen(storeData: storeData),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    storeData['storeImage'],
                  ),
                ),
                title: Text(storeData['businessName']),
                subtitle: Text(storeData['countryValue']),
              );
            },
          ),
        );
      },
    );
  }
}
