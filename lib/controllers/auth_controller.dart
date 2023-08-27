// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vender_store_app/utils/show_snackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multi_vender_store_app/models/buyer_model.dart';
import 'package:multi_vender_store_app/providers/buyer_providers.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> signUpUsers({
    required String email,
    required String fullName,
    required String phoneNumber,
    required String password,
    Uint8List? image,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // Create the user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String profileImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('buyers').doc(credential.user!.uid).set({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'buyerId': credential.user!.uid,
          'address': [],
          'profileImage': profileImageUrl,
        });

        res = 'Success';
      } else {
        res = 'Please field must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    String res = 'Something went wrong!';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create the user
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('UID', credential.user!.uid);

        setProvider(context, credential.user!.uid);

        res = 'Success';
      } else {
        res = 'Please field must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid Password.';
      }
    } catch (e) {
      res = e.toString();
      // print(e.toString());
    }
    return res;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print("No Image Selected");
    }
  }

  _uploadProfileImageToStorage(Uint8List? image,
      {bool isOldDelete = false}) async {
    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);

    UploadTask task = ref.putData(image!, metadata);
    TaskSnapshot snapshot = await task;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  getBuyer(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? uid = pref.getString("UID");
      // print("DONE : $uid");

      if (uid == null) {
        return pref.setString("UID", '');
      }
      // set User Provider
      setProvider(context, uid);
    } catch (e) {
      throw e.toString();
    }
  }

  setProvider(BuildContext context, String uid) async {
    // New method
    Provider.of<BuyerProvider>(context, listen: false).setBuyerFromModel(
      Buyer.fromJsonDocumentSnapshot(
        await _firestore.collection('buyers').doc(uid).get(),
      ),
    );

    // Old Method
    // DocumentSnapshot buyerData = await _firestore
    //     .collection('buyers')
    //     .doc(credential.user!.uid)
    //     .get();

    // Buyer buyer = Buyer.fromJsonDocumentSnapshot(buyerData);

    // var buyerProvider = Provider.of<BuyerProvider>(context, listen: false);
    // buyerProvider.setBuyerFromModel(buyer);
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("UID", "");
    await _auth.signOut();
  }

  editUsers({
    required BuildContext context,
    required Buyer buyer,
    Uint8List? image,
  }) async {
    String res = 'Something went wrong!';
    EasyLoading.show();
    try {
      String? profileImageUrl = buyer.profileImage;
      if (image != null) {
        profileImageUrl = await _uploadProfileImageToStorage(image);
      }
      await _firestore.collection("buyers").doc(buyer.buyerId).update({
        "fullName": buyer.name,
        "phoneNumber": buyer.phoneNumber,
        "address": buyer.address,
        "profileImage": profileImageUrl,
      }).whenComplete(() {
        // Provider.of<BuyerProvider>(context, listen: false).setBuyerFromModel(buyer);
        getBuyer(context);
        showSnackBar(context, "Profile Update Successfully");
        Navigator.pop(context);
      });
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    EasyLoading.dismiss();
    return res;
  }
}
