import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/models/cart_model.dart';
import 'package:multi_vender_store_app/providers/cart_provider.dart';
import 'package:multi_vender_store_app/utils/show_snackBar.dart';
import 'package:multi_vender_store_app/views/buyers/productDetail/product_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;
  const ProductDetailScreen({super.key, this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController pageController = PageController();
  String? _selectedSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
      keepPage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData['productName'],
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductImages(
                        productData: widget.productData,
                        currentIndex: int.tryParse(
                          pageController.page!.round().toString(),
                        ),
                      ),
                    ),
                  );
                },
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  pageController: pageController,
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions.customChild(
                      disableGestures: true,
                      // imageProvider: NetworkImage(
                      //     productData['productImages'][index].toString()),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.productData['productImages'][index],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.productData['productImages'][index]
                            .toString(),
                      ),
                    );
                  },
                  loadingBuilder: (context, event) => Shimmer(
                    duration: const Duration(seconds: 10), //Default value
                    interval: const Duration(
                        seconds: 10), //Default value: Duration(seconds: 0)
                    color: Colors.grey, //Default value
                    colorOpacity: 0.5, //Default value
                    enabled: true, //Default value
                    direction:
                        const ShimmerDirection.fromLTRB(), //Default Value
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.white),
                  itemCount: widget.productData['productImages'].length,
                ),
              ),
            ),
            DotsIndicator(
              dotsCount: widget.productData['productImages'].length,
              position: 0,
              // position: _pageController.page!.round(),
              decorator: const DotsDecorator(
                color: Colors.black87, // Inactive color
                activeColor: Colors.redAccent,
              ),
              onTap: (position) {
                pageController.jumpToPage(position);
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                currencyFormat.format(widget.productData['price']),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.primaryColor),
              ),
            ),
            Text(
              widget.productData['productName'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Description',
                    style: TextStyle(color: GlobalVariables.primaryColor),
                  ),
                  Text(
                    'View More',
                    style: TextStyle(color: GlobalVariables.primaryColor),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData['description'],
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "This Product Will Be Shipping On",
                  style: TextStyle(
                    color: GlobalVariables.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  DateFormat("dd/MM/yyyy").format(
                    widget.productData['scheduleDate'].toDate(),
                  ),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.productData['sizeList'].isEmpty ? false : true,
              child: ExpansionTile(
                title: const Text("Available Sizes"),
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['sizeList'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActionChip(
                            backgroundColor: _selectedSize ==
                                    widget.productData['sizeList'][index]
                                ? GlobalVariables.primaryColor
                                : null,
                            onPressed: () {
                              setState(() {
                                _selectedSize =
                                    widget.productData['sizeList'][index];
                              });
                            },
                            label: Text(
                              widget.productData['sizeList'][index],
                              style: TextStyle(
                                color: _selectedSize ==
                                        widget.productData['sizeList'][index]
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (!cartProvider.getCartItems
                .containsKey(widget.productData['productId'])) {
              if (widget.productData['sizeList'].isNotEmpty) {
                if (_selectedSize != null) {
                  cartProvider.addToCartFromJsonDocumentSnapshot(
                      widget.productData, _selectedSize);
                  return showSnackBar(
                    context,
                    "You Added ${widget.productData['productName']} To Your Cart",
                  );
                } else {
                  return showSnackBar(context, "Please Select Size");
                }
              } else {
                cartProvider.addToCartFromJsonDocumentSnapshot(
                    widget.productData, _selectedSize);
              }
            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cartProvider.getCartItems
                      .containsKey(widget.productData['productId'])
                  ? Colors.grey
                  : GlobalVariables.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.shopping_cart,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cartProvider.getCartItems
                            .containsKey(widget.productData['productId'])
                        ? "In Cart"
                        : "Add To Cart",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
