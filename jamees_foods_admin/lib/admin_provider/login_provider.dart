import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_admin/model/admin_login_resposemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jamees_foods_admin/model/base_url.dart';

class AdminProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _responseMessage;
  AdminLoginResponse? _adminLoginResponse;

  bool get isLoading => _isLoading;
  String? get responseMessage => _responseMessage;
  AdminLoginResponse? get adminLoginResponse => _adminLoginResponse;

  Future<bool> loginAdmin(String email, String password) async {
    String url = '$baseUrl/admin/adminlogin'; // Ensure baseUrl is correct

    Map<String, String> requestData = {
      "email": email,
      "password": password,
    };

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        _adminLoginResponse = AdminLoginResponse.fromJson(responseData);
        _responseMessage = _adminLoginResponse!.message;

        // Extract access token properly
        String? accessToken = responseData['access_token'];
        if (accessToken != null && accessToken.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', accessToken);

          _isLoading = false;
          notifyListeners();
          return true; // Login successful
        } else {
          _responseMessage = 'Access token is missing';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _responseMessage = 'Error ${response.statusCode}: ${response.body}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _responseMessage = 'Exception: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
