import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String vendorId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final int productStock;
  final List<String> productImages;
  final String productSize;
  final Timestamp scheduleDate;

  CartModel({
    required this.vendorId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.productStock,
    required this.productImages,
    required this.productSize,
    required this.scheduleDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'productStock': productStock,
      'productImages': productImages,
      'productSize': productSize,
      'scheduleDate': scheduleDate,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      vendorId: map['vendorId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      productStock: map['stock']?.toInt() ?? 0,
      productImages: List<String>.from(map['productImages']),
      productSize: map['productSize'] ?? '',
      scheduleDate: map['scheduleDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  factory CartModel.fromJsonDocumentSnapshot(DocumentSnapshot<Object?> snapshot) =>
      CartModel.fromMap(snapshot.data() as Map<String, dynamic>);


  CartModel copyWith({
    String? vendorId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    int? productStock,
    List<String>? productImages,
    String? productSize,
    Timestamp? scheduleDate,
  }) {
    return CartModel(
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productStock: productStock ?? this.productStock,
      productImages: productImages ?? this.productImages,
      productSize: productSize ?? this.productSize,
      scheduleDate: scheduleDate ?? this.scheduleDate,
    );
  }
}
