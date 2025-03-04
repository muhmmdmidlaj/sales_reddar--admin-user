import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_admin/admin_provider/admin_logout.dart';
import 'package:jamees_foods_admin/model/base_url.dart';
import 'package:jamees_foods_admin/model/user_model.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> _activeUsers = [];
  List<UserModel> _deactivatedUsers = [];

  bool _isLoading = false;
  String? _errorMessage;

  bool isActiveLoading = false;
  bool isActive = false;

  List<UserModel> get users => _users;
  List<UserModel> get activeUsers => _activeUsers;
  List<UserModel> get deactivatedUsers => _deactivatedUsers;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all users and separate them into active & deactivated categories
  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/admin/getalluseradmin');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    var headers = {
      'Authorization': 'Bearer $token',
    };

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);

        if (jsonData.containsKey('users')) {
          List<UserModel> fetchedUsers = (jsonData['users'] as List)
              .map((user) => UserModel.fromMap(user))
              .toList();

          _users = fetchedUsers;
          _activeUsers = fetchedUsers.where((user) => user.isActive).toList();
          _deactivatedUsers =
              fetchedUsers.where((user) => !user.isActive).toList();

          notifyListeners();
        } else {
          throw FormatException("Invalid response format from server.");
        }
      } else {
        throw HttpException(
            'Failed to load users. Status code: ${response.statusCode}');
      }
    } on SocketException {
      _errorMessage = 'No internet connection. Please check your network.';
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again later.';
    } on HttpException catch (e) {
      _errorMessage = 'HTTP error: ${e.message}';
    } on FormatException {
      _errorMessage =
          'Invalid response format. The server response might be corrupted.';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activateDeactivateUser(int storeId,context) async {
    isActiveLoading = true;
    notifyListeners();
    final String apiUrl =
        'https://jamees-foods-backend.onrender.com/admin/activate-deactivate-user/$storeId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    // Replace with your real token mechanism
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      isActiveLoading = true;
      var request = http.Request('PUT', Uri.parse(apiUrl));
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 3));

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);
        isActive = !isActive;
        isActiveLoading = false;
        notifyListeners();
        print("✅ Store updated successfully: $jsonData");
      }else if (response.statusCode == 401) {
        // Unauthorized - Invalid Token, logout user
        
        notifyListeners();
        await logoutUser(context);
        return;
      } else {
        throw HttpException(
            "Failed to update store. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}");
      }
    } on SocketException {
      print("❌ No internet connection. Please check your network.");
    } on TimeoutException {
      print("❌ Request timed out. Please try again later.");
    } on HttpException catch (e) {
      print("❌ HTTP error: ${e.message}");
    } on FormatException {
      print(
          "❌ Invalid response format. The server response might be corrupted.");
    } catch (e) {
      print("❌ An unexpected error occurred: $e");
      isActiveLoading = false;
      isActive = !isActive;
    } finally {
      isActiveLoading = false;
    }
  }
}
