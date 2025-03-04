import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_frontend/Model/base_url.dart';
import 'package:jamees_foods_frontend/Model/store_create_model.dart';
import 'package:jamees_foods_frontend/controller/provider/regenerating_tocken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? selectedEmirate;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final List<String> emirates = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm Al-Quwain',
    'Ras Al Khaimah',
    'Fujairah'
  ];

  void setEmirate(String? value) {
    selectedEmirate = value;
    notifyListeners();
  }

  Future<void> createStore(BuildContext context) async {
    if (storeNameController.text.isEmpty ||
        numberController.text.isEmpty ||
        areaController.text.isEmpty ||
        selectedEmirate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print("⛔ Access token not found or empty. Trying to refresh...");

      // ✅ Await the function call and properly assign its return value
      bool tokenRefreshed = await regenerateAccessToken(context);
      if (!tokenRefreshed) {
        print("⛔ Failed to refresh token. Logging out user...");
        await logoutUser(context);
        return;
      }

      // ✅ Re-fetch the updated token after refreshing
      accessToken = prefs.getString('access_token');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    var url = Uri.parse('$baseUrl/store/createstore');

    try {
      Store store = Store(
        storeName: storeNameController.text,
        storePhoneNumber: numberController.text,
        storeArea: areaController.text,
        storeEmirate: selectedEmirate!,
      );

      var response = await http.post(
        url,
        headers: headers,
        body: store.toJsonString(),
      );

      _isLoading = false;
      notifyListeners();

      final responseData = jsonDecode(response.body);
      final message =
          responseData["message"] ?? "Unexpected response from server.";

      if (response.statusCode == 201) {
        showResponseDialog(context, "Success", message, true);
        await clearField();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print(
            "⛔ Unauthorized! Access token might be expired. Trying to refresh...");

        bool tokenRefreshed = await regenerateAccessToken(context);
        if (tokenRefreshed) {
          print("🔄 Token refreshed successfully. Retrying request...");
          await createStore(
              context); // ✅ Retry the request after refreshing token
        } else {
          print("⛔ Refresh token also expired. Logging out...");
          await logoutUser(context);
        }
      } else {
        showResponseDialog(context, "Error", message, false);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showResponseDialog(
          context, "Network Error", "Something went wrong: $e", false);
    }
  }

  Future<void> clearField() async {
    storeNameController.clear();
    numberController.clear();
    areaController.clear();
    selectedEmirate = null;
  }

  void showResponseDialog(
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
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 70.h,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message, // Display response message
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'OK',
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
