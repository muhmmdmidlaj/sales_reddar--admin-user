import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_admin/admin_provider/admin_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/each_user_model.dart';

class SalesmanProvider with ChangeNotifier {
  EachUserResponse? _salesmanDetails;
  bool _isLoading = false;
  String? _errorMessage;

  EachUserResponse? get salesmanDetails => _salesmanDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSalesmanDetails(int salesmanId,context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      _errorMessage = 'Authorization token is missing. Please log in again.';
      notifyListeners();
      return;
    }

    final url = Uri.parse('https://jamees-foods-backend.onrender.com/admin/geteachsalesmandetails/$salesmanId');
    var headers = {'Authorization': 'Bearer $token'};

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(responseBody);

        _salesmanDetails = EachUserResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        _errorMessage = 'Session expired. Logging out...';
        notifyListeners();
        await logoutUser(context);
      } else if (response.statusCode == 403) {
        _errorMessage = 'Forbidden access. You do not have permission.';
      } else if (response.statusCode == 404) {
        _errorMessage = 'Salesman details not found.';
      } else if (response.statusCode == 500) {
        _errorMessage = 'Server error. Please try again later.';
      } else {
        _errorMessage = 'Unexpected error: ${response.statusCode}';
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
}
