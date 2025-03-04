import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/user_view/sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  // String? _accessToken;
  // String? _refreshToken;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // String? get accessToken => _accessToken;

  Future<bool> loginUser(
      BuildContext context, String phone, String password) async {
    const String url = 'https://jamees-foods-backend.onrender.com/user/login';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      "user_phone": phone,
      "user_password": password
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      _isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _errorMessage = null;
        final responseData = json.decode(response.body);
        final _accessToken = responseData["access_token"];
        final _refreshToken = responseData["refresh_token"];

        // Store tokens in SharedPreferences
        await prefs.setString('access_token', _accessToken);
        await prefs.setString('refresh_token', _refreshToken);

        // Show success dialog
        _showAlertDialog(context, "Login Successful", "Welcome back!", true);
        return true;
      } else {
        _errorMessage =
            'Login Failed: ${response.statusCode} - ${response.body}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Future<void> _storeTokens(String accessToken, String refreshToken) async {}

  // Future<void> loadToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _accessToken = prefs.getString('access_token');
  //   _refreshToken = prefs.getString('refresh_token');
  //   notifyListeners();
  // }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    // _accessToken = null;
    // _refreshToken = null;
    notifyListeners();
  }

  bool isPasswordHidden = true;
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  void _showAlertDialog(
      BuildContext context, String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 70),
              SizedBox(height: 15),
              Text(
                '$title',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '$message',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SidebarWithTabView()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
