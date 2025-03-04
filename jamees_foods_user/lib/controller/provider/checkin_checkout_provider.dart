import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jamees_foods_frontend/controller/provider/regenerating_tocken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreVisitProvider with ChangeNotifier {
  final String _baseUrl = 'https://jamees-foods-backend.onrender.com/store';

  TextEditingController salesAmountController = TextEditingController();
  bool _ischknLoading = false;
  bool _ischkoutLoading = false;
  String? _message;
  Map<int, Map<String, dynamic>> _storeVisits = {}; // Track visitData per store
  bool ischeckin = false;

  bool get ischknLoading => _ischknLoading;
  bool get ischktLoading => _ischkoutLoading;
  String? get message => _message;

  Map<int, Map<String, dynamic>> get storeVisits => _storeVisits;

  /// **🔹 Check-In Function (Per Store)**
  Future<void> checkIn(int storeId, BuildContext context) async {
    _ischknLoading = true;
    _message = null;
    notifyListeners();

    try {
      String? accessToken = await _getValidAccessToken(context);
      if (accessToken == null) return;

      final Uri url = Uri.parse('$_baseUrl/checkin/$storeId');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "checkInTime": DateTime.now().toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _storeVisits[storeId] = json.decode(response.body);
        ischeckin = true;

        _message = "✅ Check-in successful";
      } else {
        _message = "⚠️ Check-in failed: ${response.reasonPhrase}";
      }
    } catch (error) {
      _message = "❌ An error occurred: $error";
    } finally {
      _ischknLoading = false;
      notifyListeners();
    }
  }

  /// **🔹 Check-Out Function (Per Store)**
  Future<void> checkOut(
      int storeId, int salesAmount, BuildContext context) async {
    _ischkoutLoading = true;
    _message = null;
    notifyListeners();

    try {
      String? accessToken = await _getValidAccessToken(context);
      if (accessToken == null) return;

      final Uri url = Uri.parse('$_baseUrl/checkout/$storeId');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "sales_Amount": salesAmount.toString(),
          "checkoutTime": DateTime.now().toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);

        print(
            'responnnnnsssssssssssss----------- time: ${responseData['visit']['checkin_Time']}');
        _storeVisits.remove(storeId); // Remove visitData for this store
        salesAmountController.clear();
        ischeckin = false;

        _message = "✅ Checkout successful";
        _showCheckoutDialog(context, responseData['visit']);
      } else {
        _message = "⚠️ Checkout failed: ${response.reasonPhrase}";
      }
    } catch (error) {
      _message = "❌ An error occurred: $error";
    } finally {
      _ischkoutLoading = false;
      notifyListeners();
    }
  }

  void _showCheckoutDialog(
      BuildContext context, Map<String, dynamic> visitData) {
    String checkInTime = formatDateTime(visitData['checkin_Time']);
    String checkOutTime = formatDateTime(visitData['checkout_Time']);
    String salesAmount = visitData['sales_Amount'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          content: SizedBox(
            width: 200.w,
            height: 350.h,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 70),
                  const SizedBox(height: 8),
                  const Text(
                    'Successful',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "You have successfully checked out",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _infoRow("Amount:", "₹$salesAmount"),
                  _infoRow("Checked-In:", checkInTime),
                  _infoRow("Checked-Out:", checkOutTime),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Continue",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return "N/A";
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat("MMM d, yyyy | hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  /// **🔹 Get a Valid Access Token**
  Future<String?> _getValidAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print("⛔ No access token found. Attempting to refresh...");
      bool tokenRefreshed = await regenerateAccessToken(context);
      if (!tokenRefreshed) {
        print("❌ Token refresh failed. Logging out user...");
        return null;
      }
      accessToken = prefs.getString('access_token');
    }
    return accessToken;
  }
}
