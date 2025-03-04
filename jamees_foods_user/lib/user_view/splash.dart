import 'package:flutter/material.dart';
import 'package:jamees_foods_frontend/user_view/sidemenu.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jamees_foods_frontend/user_view/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check token and navigate accordingly
  }

  /// ✅ **Check if User is Logged In**
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    /// Wait for splash screen duration (3 sec)
    await Future.delayed(Duration(seconds: 3));

    /// If token exists, navigate to `SidebarWithTabView`, else `LoginPage`
    if (accessToken != null && accessToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SidebarWithTabView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Image.asset('asset/image/logo.png'), // Splash logo
        ),
      ),
    );
  }
}
