import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Buyer {
  final String id;
  final String name;
  final String email;
  final String address;
  final String profileImage;
  final String phoneNumber;
  Buyer({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.profileImage,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
    };
  }

  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['buyerId'] ?? '',
      name: map['fullName'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      profileImage: map['profileImage'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Buyer.fromJson(String source) => Buyer.fromMap(json.decode(source));

  factory Buyer.fromJsonDocumentSnapshot(DocumentSnapshot<Object?> snapshot) =>
      Buyer.fromMap(snapshot.data() as Map<String, dynamic>);

  Buyer copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? profileImage,
    String? phoneNumber,
  }) {
    return Buyer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
