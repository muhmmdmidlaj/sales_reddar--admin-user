import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jamees_foods_admin/admin_provider/admin_logout.dart';
import 'package:jamees_foods_admin/model/base_url.dart';
import 'package:jamees_foods_admin/model/store_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedStoreProvider with ChangeNotifier {
  Store? _selectedStore;
  List<Store> _activatedStores = [];
  List<Store> _deActivatedStores = [];

  String? _message;

  Store? get selectedStore => _selectedStore;
  List<Store> get activatedStores => _activatedStores;
  List<Store> get deActivatedStores => _deActivatedStores;

  String? get message => _message;

  void selectStore(Store store) {
    _selectedStore = store;
    notifyListeners();
  }

  void clearSelection() {
    _selectedStore = null;
    notifyListeners();
  }

  Future<void> fetchStores() async {
    final url = Uri.parse('$baseUrl/admin/getallstoreadmin');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token is missing. Please log in again.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 3)); // Adding timeout for request

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final storeResponse = StoreResponse.fromJson(data);

        _message = storeResponse.message;
        _activatedStores = storeResponse.activatedStores;
        _deActivatedStores = storeResponse.deactivatedStores;
        print(_deActivatedStores);
        print('hioiiiiiiiiiiiiiiiiiiiiiiii ${_deActivatedStores.length}');

        notifyListeners();
      } else {
        throw HttpException(
            'Failed to load stores. Status code: ${response.statusCode}');
      }
    } on SocketException {
      print('No internet connection. Please check your network.');
    } on TimeoutException {
      print('Request timed out. Please try again later.');
    } on HttpException catch (e) {
      print('HTTP error: ${e.message}');
    } on FormatException {
      print('Bad response format. The server response might be corrupted.');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<void> activateDeactivateStore(int storeId,context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(
        'https://jamees-foods-backend.onrender.com/admin/activate-deactivate-store/$storeId');

    try {
      var request = http.Request('PUT', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('Success: ${await response.stream.bytesToString()}');
      }else if (response.statusCode == 401) {
        // Unauthorized - Invalid Token, logout user
        
        notifyListeners();
        await logoutUser(context);
        return;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on SocketException {
      print('No internet connection. Please check your network.');
    } on HttpException {
      print('HTTP error occurred. Please try again later.');
    } on FormatException {
      print('Bad response format. The server response might be corrupted.');
    } on TimeoutException {
      print('Request timed out. Please try again later.');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  void toggleStoreActivation(Store store) {
    final isActive = store.isActive;
    final updatedStore = Store(
      storeId: store.storeId,
      storeName: store.storeName,
      storePhoneNumber: store.storePhoneNumber,
      storeArea: store.storeArea,
      storeEmirate: store.storeEmirate,
      createdBy: store.createdBy,
      isActive: !isActive, // Toggle the state
    );

    // Update the selected store state if it is toggled
    if (_selectedStore?.storeId == store.storeId) {
      _selectedStore = updatedStore;
    }

    // Update the store in the list
    final index =
        _activatedStores.indexWhere((s) => s.storeId == store.storeId);
    if (index != -1) {
      _activatedStores[index] = updatedStore;
    }

    notifyListeners();
  }
}
