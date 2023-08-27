import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Stream<QuerySnapshot> productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  String searchedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        elevation: 0,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              searchedValue = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Search For Products',
            labelStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 4,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: searchedValue == ''
          ? const Center(
              child: Text(
                'Search For Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: GlobalVariables.primaryColor),
                  );
                }

                final searchedData = snapshot.data!.docs.where(
                  (element) {
                    return element['productName']
                        .toLowerCase()
                        .contains(searchedValue.toLowerCase());
                  },
                );

                return Column(
                  children: searchedData.map((e) {
                    return Card(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(e['productImages'][0]),
                          ),
                          Column(
                            children: [
                              Text(
                                e['productName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currencyFormat.format(e['price']),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
