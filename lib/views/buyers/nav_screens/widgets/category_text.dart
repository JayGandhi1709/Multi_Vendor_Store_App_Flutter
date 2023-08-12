import 'package:flutter/material.dart';

class CategoryText extends StatelessWidget {
  const CategoryText({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categoryLabel = ['Food', 'Vegetable', 'Egg', 'Tea'];

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
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryLabel.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ActionChip(
                          backgroundColor: Colors.yellow.shade900,
                          onPressed: (){},
                          label: Center(
                            child: Text(
                              categoryLabel[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
          )
        ],
      ),
    );
  }
}
