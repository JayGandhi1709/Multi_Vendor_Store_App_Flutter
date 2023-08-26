import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductImages extends StatefulWidget {
  final dynamic productData;
  final int? currentIndex;
  const ProductImages({
    super.key,
    required this.productData,
    this.currentIndex = 0,
  });

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _pageController = PageController(
      initialPage: widget.currentIndex ?? 0,
      viewportFraction: 1,
      keepPage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SizedBox(
          height: 500,
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index) => setState(() {}),
            pageController: _pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                basePosition: Alignment.center,
                imageProvider: NetworkImage(
                    widget.productData['productImages'][index].toString()),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                minScale: PhotoViewComputedScale.contained * 0.4,
                maxScale: PhotoViewComputedScale.covered * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.productData['productImages'][index]),
              );
            },
            loadingBuilder: (context, event) => Shimmer(
              duration: const Duration(seconds: 10), //Default value
              interval: const Duration(
                  seconds: 10), //Default value: Duration(seconds: 0)
              color: Colors.grey, //Default value
              colorOpacity: 0.5, //Default value
              enabled: true, //Default value
              direction: const ShimmerDirection.fromLTRB(), //Default Value
              child: Container(
                height: 500,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.white),
            itemCount: widget.productData['productImages'].length,
          ),
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.productData['productImages'].length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                _pageController.jumpToPage(index);
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // border: Border.all(color: GlobalVariables.primaryColor),
                  border: Border(
                    bottom: BorderSide(
                      color: _pageController.page!.round() == index
                          ? Colors.black
                          : Colors.transparent,
                      width: 10,
                    ),
                  ),
                ),
                height: 40,
                width: 40,
                child: Image.network(
                  widget.productData['productImages'][index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
