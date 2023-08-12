// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/controllers/auth_controller.dart';
import 'package:multi_vender_store_app/utils/show_snack_bar.dart';
import 'package:multi_vender_store_app/views/buyers/auth/register_screen.dart';
import 'package:multi_vender_store_app/views/buyers/auth/widgets/custom_textformfield.dart';
import 'package:multi_vender_store_app/views/buyers/auth/widgets/loader.dart';
import 'package:multi_vender_store_app/views/buyers/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _signInUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await authController
          .signInUsers(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });

      if (res == 'Success') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false);
        return showSnackBar(context, 'You Are Now Logged In');
      } else {
        return showSnackBar(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Please Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login Customer\'s Account',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                CustomTextFormField(
                  labelText: 'Email',
                  hintText: 'Enter Email',
                  controller: _emailController,
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
                        _obscureText != _obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      color: _obscureText ? null : Colors.yellow.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _signInUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const Loader()
                          : const Text(
                              'LOGIN',
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      // style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.yellow.shade900,
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
    );
  }
}
