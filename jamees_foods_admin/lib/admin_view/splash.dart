import 'package:flutter/material.dart';
import 'dart:async';

import 'package:jamees_foods_admin/admin_view/login.dart';
import 'package:jamees_foods_admin/admin_view/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? isLoggedIn;
  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      checkTokenValidity().then((isValid) {
        if (isValid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminSidebarWithTabView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      });
    });
  }

  Future<bool> checkTokenValidity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedin = prefs.getBool('isLoggedIn');

    if (isLoggedin != null && isLoggedin) {
      // Optional: Validate token with backend if necessary
      return isLoggedin; // Assume token is valid for simplicity
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Image.asset('asset/image/logo.png'),
        ),
      ),
    );
  }
}
