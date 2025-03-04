import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/user_view/sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider with ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;

  /// Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  /// Signup and Handle Navigation + Alerts
  Future<void> signupUser(BuildContext context) async {
    final String url = 'https://jamees-foods-backend.onrender.com/user/signup';

    isLoading = true;
    notifyListeners();

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_name": usernameController.text,
          "user_password": passwordController.text,
          "user_phone": phoneNumberController.text,
        }),
      );

      isLoading = false;
      notifyListeners();

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        /// Save Tokens to SharedPreferences
        await _saveTokens(data['access_token'], data['refresh_token']);

        /// Show success alert and navigate
        _showAlertDialog(context, "Success", "Signup Successful!", true);
      } else {
        /// Show error alert
        _showAlertDialog(
            context, "Error", data['message'] ?? "Signup Failed", false);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showAlertDialog(context, "Error", "An error occurred: $e", false);
    }
  }

  /// Save Tokens to SharedPreferences
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
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

  /// Show Alert Dialog
}
