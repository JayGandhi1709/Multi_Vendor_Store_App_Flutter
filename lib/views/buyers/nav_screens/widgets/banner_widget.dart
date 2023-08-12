import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final _firestore = FirebaseFirestore.instance;
  bool isDataLoading = true;

  final List _bannerImage = [];

  getBanner() {
    return _firestore.collection("banners").get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            setState(() {
              _bannerImage.add(doc['image']);
            });
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isDataLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: isDataLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.25),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
              ))
          : Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.yellow.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PageView.builder(
                itemCount: _bannerImage.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _bannerImage[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
