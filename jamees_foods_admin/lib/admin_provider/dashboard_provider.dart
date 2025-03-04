import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_admin/admin_provider/admin_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  // User Data
  int totalUsers = 0;
  int activeUsers = 0;
  int deactivatedUsers = 0;

  // Store Data
  int totalStores = 0;
  int activeStores = 0;
  int deactivatedStores = 0;

  String errorMessage = '';

  final String baseUrl = 'https://jamees-foods-backend.onrender.com/admin';

  /// Fetch User Count
  Future<void> fetchUserCount(context) async {
    await _fetchData('$baseUrl/users/count', 'user', context);
  }

  /// Fetch Store Count
  Future<void> fetchStoreCount(context) async {
    await _fetchData('$baseUrl/stores/count', 'store', context);
  }

  /// Generic function to fetch and update data
  Future<void> _fetchData(String url, String type, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (type == 'user') {
          totalUsers = data['totalUsers'] ?? 0;
          activeUsers = data['activeUsers'] ?? 0;
          deactivatedUsers = data['deactivatedUsers'] ?? 0;
        } else if (type == 'store') {
          totalStores = data['totalStores'] ?? 0;
          activeStores = data['activeStores'] ?? 0;
          deactivatedStores = data['deactivatedStores'] ?? 0;
        }

        errorMessage = '';
      } else if (response.statusCode == 401) {
        // Unauthorized - Invalid Token, logout user
        errorMessage = 'Session expired. Logging out...';
        notifyListeners();
        await logoutUser(context);
        return;
      } else {
        errorMessage = 'Failed to fetch $type count: ${response.reasonPhrase}';
      }
    } on SocketException {
      errorMessage = 'No Internet Connection';
    } on HttpException {
      errorMessage = 'Couldn\'t reach the server';
    } on FormatException {
      errorMessage = 'Invalid JSON format';
    } on TimeoutException {
      errorMessage = 'Request timed out';
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
    }

    notifyListeners();
  }
}
