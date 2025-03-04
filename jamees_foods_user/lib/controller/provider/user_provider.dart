import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/Model/user_profile_model.dart';
import 'package:jamees_foods_frontend/controller/provider/regenerating_tocken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  /// **Fetch User Profile**
  Future<void> fetchUserProfile(context) async {
    const String url = 'https://jamees-foods-backend.onrender.com/user/profile';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print("⛔ No access token found. Attempting to refresh...");
      bool tokenRefreshed = await regenerateAccessToken(context);
      if (!tokenRefreshed) {
        print("❌ Token refresh failed. Logging out user...");
        await logoutUser(context);
        return;
      }
      accessToken = prefs.getString('access_token');
    }

    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _user = User.fromJson(data);
        print("✅ User profile fetched successfully!");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("⛔ Access token expired. Attempting to refresh...");
        bool tokenRefreshed = await regenerateAccessToken(context);

        if (tokenRefreshed) {
          await fetchUserProfile(context);
        } else {
          print("❌ Token refresh failed. Logging out...");
          await logoutUser(context);
        }
      } else {
        _errorMessage =
            "⚠️ Failed to load user data: ${response.statusCode} ${response.reasonPhrase}";
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = "❌ Error fetching user profile: $e";
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Update User Profile (Name & Email)**
  Future<void> updateUserProfile(BuildContext context, String newName, String newEmail) async {
    const String url = 'https://jamees-foods-backend.onrender.com/user/profile';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print("⛔ No access token found. Attempting to refresh...");
      bool tokenRefreshed = await regenerateAccessToken(context);
      if (!tokenRefreshed) {
        print("❌ Token refresh failed. Logging out user...");
        await logoutUser(context);
        return;
      }
      accessToken = prefs.getString('access_token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    final body = jsonEncode({
      "user_name": newName,
      "user_email": newEmail
    });

    _isUpdating = true;
    notifyListeners();

    try {
      final response = await http.patch(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print("✅ Profile updated successfully!");
        _user = User(
          userName: newName,
          userEmail: newEmail,
          userPhone: _user?.userPhone ?? '',
        );
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print("⛔ Access token expired. Attempting to refresh...");
        bool tokenRefreshed = await regenerateAccessToken(context);

        if (tokenRefreshed) {
          await updateUserProfile(context, newName, newEmail);
        } else {
          print("❌ Token refresh failed. Logging out...");
          await logoutUser(context);
        }
      } else {
        print("⚠️ Error updating profile: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Error updating profile: $e");
    }

    _isUpdating = false;
    notifyListeners();
  }
}
