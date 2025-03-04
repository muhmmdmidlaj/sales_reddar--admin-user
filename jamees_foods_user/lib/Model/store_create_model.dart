import 'dart:convert';

class Store {
  final String storeName;
  final String storePhoneNumber;
  final String storeArea;
  final String storeEmirate;

  Store({
    required this.storeName,
    required this.storePhoneNumber,
    required this.storeArea,
    required this.storeEmirate,
  });

  // Factory method to create a Store object from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeName: json['store_name'],
      storePhoneNumber: json['store_phonenumber'],
      storeArea: json['store_area'],
      storeEmirate: json['store_emirate'],
    );
  }

  // Convert Store object to JSON
  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'store_phonenumber': storePhoneNumber,
      'store_area': storeArea,
      'store_emirate': storeEmirate,
    };
  }

  // Convert JSON string to Store object
  static Store fromJsonString(String jsonString) {
    return Store.fromJson(json.decode(jsonString));
  }

  // Convert Store object to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}
