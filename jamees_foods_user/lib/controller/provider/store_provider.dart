import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/Model/user_store_model.dart';
import 'package:jamees_foods_frontend/controller/provider/regenerating_tocken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStoreProvider with ChangeNotifier {
  List<GetStore> _stores = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<GetStore> get stores => _stores;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String _baseUrl =
      "https://jamees-foods-backend.onrender.com/store/getallstore";

  /// **🔹 Fetch Stores with Token Handling**
  Future<void> fetchStores(context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      
      String? accessToken = await _getValidAccessToken(context);
      if (accessToken == null) return;

      var headers = {'Authorization': 'Bearer $accessToken'};
      var request = http.Request('GET', Uri.parse(_baseUrl));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        _stores = (jsonData['stores'] as List)
            .map((store) => GetStore.fromJson(store))
            .toList();
        print("✅ Stores fetched successfully!");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("⛔ Access token expired. Attempting to refresh...");
        bool tokenRefreshed = await regenerateAccessToken(context);
        if (tokenRefreshed) {
          print("🔁 Token refreshed successfully! Retrying fetchStores...");
          await fetchStores(context); // Retry after token refresh
        } else {
          print("❌ Token refresh failed. Logging out user...");
          await logoutUser(context);
        }
      } else {
        _errorMessage = "⚠️ Error: ${response.reasonPhrase}";
      }
    } on http.ClientException {
      _errorMessage = "❌ Connection failed. Please check your internet.";
    } on FormatException {
      _errorMessage = "❌ Invalid response format.";
    } on TimeoutException {
      _errorMessage = "❌ Request timeout. Please try again.";
    } catch (e) {
      _errorMessage = "❌ An unexpected error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **🔹 Get a Valid Access Token (Regenerates if Expired)**
  Future<String?> _getValidAccessToken(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print("⛔ No access token found. Attempting to refresh...");
      bool tokenRefreshed = await regenerateAccessToken(context);
      if (!tokenRefreshed) {
        print("❌ Token refresh failed. Logging out user...");
        await logoutUser(context);
        return null;
      }
      accessToken = prefs.getString('access_token'); // Get new token
    }

    return accessToken;
  }
}
