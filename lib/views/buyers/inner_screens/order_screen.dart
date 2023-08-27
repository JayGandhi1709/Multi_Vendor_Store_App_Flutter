import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: const Text(
          "My orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
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

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: document['accepted']
                          ? const Icon(Icons.delivery_dining)
                          : const Icon(Icons.access_time),
                    ),
                    title: document['accepted']
                        ? Text(
                            "Accepted",
                            style: TextStyle(
                              color: GlobalVariables.primaryColor,
                            ),
                          )
                        : const Text(
                            "Not Accepted",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(
                        document['orderDate'].toDate(),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      "Amount : ${currencyFormat.format(document['productPrice'])}",
                      style: TextStyle(
                        color: GlobalVariables.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      "Order Details",
                      style: TextStyle(
                        color: GlobalVariables.primaryColor,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text("View Order Details"),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                            document['productImages'][0],
                          ),
                        ),
                        title: Text(document['productName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Quantity",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  document['quantity'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: document['accepted'],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Schedule Delivery Date"),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                      document['scheduleDate'].toDate(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                "Buyer Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document['fullName']),
                                  Text(document['email']),
                                  Text(document['phoneNumber']),
                                  Text(document['address']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
