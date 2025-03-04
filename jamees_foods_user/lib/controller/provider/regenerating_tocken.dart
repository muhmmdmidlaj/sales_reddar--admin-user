import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/user_view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> regenerateAccessToken(context) async {
  const String url =
      'https://jamees-foods-backend.onrender.com/refresh/refresh-token';

  try {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      print("⛔ Refresh token not found. Logging out user...");
      await logoutUser(context);
      return false;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refresh_token": refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey("access_token")) {
        String newAccessToken = responseData["access_token"];

        // Store the new tokens in SharedPreferences
        await prefs.setString('access_token', newAccessToken);

        print("✅ Access Token Refreshed Successfully!");
        print("🔑 New Access Token: $newAccessToken");
        return true;
      } else {
        print("⚠️ Response does not contain required tokens. Logging out...");
        await logoutUser(context);
        return false;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      print("⛔ Refresh token expired or unauthorized. Logging out user...");
      await logoutUser(context);
      return false;
    } else if (response.statusCode == 500) {
      print("⚠️ Server Error: Please try again later.");
      return false;
    } else {
      print(
          "⚠️ Unexpected Error: ${response.statusCode} - ${response.reasonPhrase}");
      return false;
    }
  } catch (e) {
    print("❌ Error Refreshing Token: $e");
    await logoutUser(context);
    return false;
  }
}

// 🔴 Function to log out the user
Future<void> logoutUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  await prefs.remove('refresh_token');

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
    (route) => false,
  );

  print("🚪 User logged out. Redirecting to login screen...");

  // TODO: Add navigation logic here to redirect user to login screen
}
