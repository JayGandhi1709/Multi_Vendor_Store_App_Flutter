import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/category_screen.dart';
import 'package:multi_vender_store_app/views/buyers/nav_screens/widgets/home_products.dart';

class CategoryText extends StatefulWidget {
  const CategoryText({super.key});

  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  final Stream<QuerySnapshot> _categoryStream =
      FirebaseFirestore.instance.collection('categories').snapshots();
  String? _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    // final List<String> categoryLabel = ['Food', 'Vegetable', 'Egg', 'Tea'];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 19,
            ),
          ),

          /// To show the list of categories in a horizontal scroll view
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Loading Categories"),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(
                          backgroundColor: _selectedCategory == "All"
                              ? GlobalVariables.primaryColor
                              : null,
                          onPressed: () {
                            setState(() {
                              _selectedCategory = "All";
                            });
                          },
                          label: Text(
                            "All",
                            style: TextStyle(
                              color: _selectedCategory == "All"
                                  ? Colors.white
                                  : null,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            String categoryLabel =
                                snapshot.data!.docs[index]['categoryName'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                backgroundColor:
                                    _selectedCategory == categoryLabel
                                        ? GlobalVariables.primaryColor
                                        : null,
                                onPressed: () {
                                  setState(() {
                                    _selectedCategory = categoryLabel;
                                  });
                                },
                                label: Text(
                                  categoryLabel,
                                  style: TextStyle(
                                    color: _selectedCategory == categoryLabel
                                        ? Colors.white
                                        : null,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          HomeProductWidget(categoryName: _selectedCategory!),
        ],
      ),
    );
  }
}
