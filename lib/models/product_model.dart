import 'dart:convert';

import 'package:multi_vender_store_app/extensions/discount_extension.dart';
import 'package:multi_vender_store_app/extensions/enum.dart';

class Product {
  final String vendorId;
  final String productName;
  final double price;
  final int quantity;
  final String category;
  final String description;
  final List<String> productImages;
  final String brandName;
  final List<String> sizeList;
  final DateTime? scheduleDate;
  final bool chargeShipping;
  final int shippingCharge;
  final bool approved;
  final bool isDiscount;
  final double discount;
  final DiscountType discountType;
  final double discountedPrice;

  Product({
    required this.vendorId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.description,
    required this.productImages,
    required this.brandName,
    required this.sizeList,
    this.scheduleDate,
    required this.chargeShipping,
    required this.shippingCharge,
    required this.approved,
    required this.isDiscount,
    required this.discount,
    required this.discountType,
    required this.discountedPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'category': category,
      'description': description,
      'productImages': productImages,
      'brandName': brandName,
      'sizeList': sizeList,
      'scheduleDate': scheduleDate?.millisecondsSinceEpoch,
      'chargeShipping': chargeShipping,
      'shippingCharge': shippingCharge,
      'approved': approved,
      'isDiscount': isDiscount,
      'discount': discount,
      'discountType': discountType,
      'discountedPrice': discountedPrice,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      vendorId: map['vendorId'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      productImages: List<String>.from(map['productImages']),
      brandName: map['brandName'] ?? '',
      sizeList: List<String>.from(map['sizeList']),
      scheduleDate: map['scheduleDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['scheduleDate']) : null,
      chargeShipping: map['chargeShipping'] ?? false,
      shippingCharge: map['shippingCharge']?.toInt() ?? 0,
      approved: map['approved'] ?? false,
      isDiscount: map['isDiscount'] ?? false,
      discount: map['discount']?.toDouble() ?? 0.0,
      discountType: DiscountExtension.fromString(map['discountType']),
      // discountType: map['discountType'] ?? DiscountType.percentage,
      discountedPrice: map['discountedPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  Product copyWith({
    String? vendorId,
    String? productName,
    double? price,
    int? quantity,
    String? category,
    String? description,
    List<String>? productImages,
    String? brandName,
    List<String>? sizeList,
    DateTime? scheduleDate,
    bool? chargeShipping,
    int? shippingCharge,
    bool? approved,
    bool? isDiscount,
    double? discount,
    DiscountType? discountType,
    double? discountedPrice,
  }) {
    return Product(
      vendorId: vendorId ?? this.vendorId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      description: description ?? this.description,
      productImages: productImages ?? this.productImages,
      brandName: brandName ?? this.brandName,
      sizeList: sizeList ?? this.sizeList,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      chargeShipping: chargeShipping ?? this.chargeShipping,
      shippingCharge: shippingCharge ?? this.shippingCharge,
      approved: approved ?? this.approved,
      isDiscount: isDiscount ?? this.isDiscount,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      discountedPrice: discountedPrice ?? this.discountedPrice,
    );
  }
}
