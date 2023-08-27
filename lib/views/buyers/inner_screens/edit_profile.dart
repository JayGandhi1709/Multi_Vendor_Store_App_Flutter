import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/controllers/auth_controller.dart';
import 'package:multi_vender_store_app/providers/buyer_providers.dart';
import 'package:multi_vender_store_app/utils/show_snackBar.dart';
import 'package:multi_vender_store_app/views/buyers/auth/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = AuthController();
  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List img = await authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyerProvider buyerProvider = Provider.of<BuyerProvider>(context);
    var buyer = buyerProvider.buyer!;

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController fullNameController =
        TextEditingController(text: buyer.name);
    final TextEditingController phoneNumberController =
        TextEditingController(text: buyer.phoneNumber);
    final TextEditingController addressController =
        TextEditingController(text: buyer.address);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              _image == null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundColor: GlobalVariables.primaryColor,
                      backgroundImage: NetworkImage(buyer.profileImage),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => selectGalleryImage(),
                      ),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundColor: GlobalVariables.primaryColor,
                      backgroundImage: MemoryImage(_image!),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => selectGalleryImage(),
                      ),
                    ),
              CustomTextFormField(
                labelText: 'Email',
                hintText: 'Enter Email',
                enabled: false,
                controller: TextEditingController(text: buyer.email),
              ),
              CustomTextFormField(
                labelText: 'Full Name',
                hintText: 'Enter Full Name',
                controller: fullNameController,
              ),
              CustomTextFormField(
                labelText: 'Phone Number',
                hintText: 'Enter Phone Number',
                controller: phoneNumberController,
              ),
              CustomTextFormField(
                labelText: 'Address',
                hintText: 'Enter Address',
                controller: addressController,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (formkey.currentState!.validate()) {
              authController.editUsers(
                context: context,
                buyer: buyer.copyWith(
                  name: fullNameController.text,
                  phoneNumber: phoneNumberController.text,
                  address: addressController.text,
                ),
                image: _image,
              );
            }
          },
          // await _firestore.collection("buyers").doc(buyer.buyerId).update({
          //   "email": emailController.text,
          //   "fullName": fullNameController.text,
          //   "phoneNumber": phoneNumberController.text,
          //   "address": addressController.text,
          //   "profileImage": _image,
          // }).whenComplete(() {
          //   Navigator.pop(context);
          //   showSnackBar(context, "Profile Update Successfully");
          //   EasyLoading.dismiss();
          // })
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: GlobalVariables.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
