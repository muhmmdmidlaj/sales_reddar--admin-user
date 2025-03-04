import 'package:flutter/material.dart';
import 'package:jamees_foods_admin/admin_view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
    (route) => false,
  );
}
