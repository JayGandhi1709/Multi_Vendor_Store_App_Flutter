import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/constant/global_variables.dart';

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: GlobalVariables.primaryColor,
      content: Text(title),
    ),
  );
}