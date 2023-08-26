// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';
import 'package:multi_vender_store_app/controllers/auth_controller.dart';
import 'package:multi_vender_store_app/utils/show_snackBar.dart';
import 'package:multi_vender_store_app/views/buyers/auth/login_screen.dart';
import 'package:multi_vender_store_app/views/buyers/auth/widgets/custom_textformfield.dart';
import 'package:multi_vender_store_app/views/buyers/auth/widgets/loader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await authController
          .signUpUsers(
        email: _emailController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        password: _passwordController.text,
        image: _image,
      )
          .whenComplete(() {
        setState(() {
          // _formKey.currentState!.reset();
          _isLoading = false;
        });
      });

      if (res == 'Success') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false);
        return showSnackBar(
            context, 'Account Has Been Created Successfully!!!');
      } else {
        return showSnackBar(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnackBar(context, 'Please Fields must not be empty');
    }
  }

  selectGalleryImage() async {
    Uint8List img = await authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Customer\'s Account ',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: GlobalVariables.primaryColor,
                          backgroundImage: MemoryImage(_image!),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () => selectGalleryImage(),
                          ),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: GlobalVariables.primaryColor,
                          backgroundImage: const AssetImage('assets/images/profile.png'),
                          child: IconButton(
                            onPressed: () => selectGalleryImage(),
                            icon: Center(
                              child: _image != null
                                  ? null
                                  : const Icon(
                                      CupertinoIcons.photo,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                  CustomTextFormField(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    controller: _emailController,
                  ),
                  CustomTextFormField(
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name',
                    controller: _fullNameController,
                  ),
                  CustomTextFormField(
                    labelText: 'Phone Number',
                    hintText: 'Enter Phone Number',
                    controller: _phoneNumberController,
                  ),
                  CustomTextFormField(
                    obscureText: _obscureText,
                    labelText: 'Password',
                    hintText: 'Password',
                    controller: _passwordController,
                    suffix: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: _obscureText ? null : GlobalVariables.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _signUpUser();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: GlobalVariables.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const Loader()
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Have An Account? ',
                        // style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: GlobalVariables.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
