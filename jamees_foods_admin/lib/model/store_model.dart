class StoreResponse {
  final String message;
  final List<Store> activatedStores;
  final List<Store> deactivatedStores;

  StoreResponse({
    required this.message,
    required this.activatedStores,
    required this.deactivatedStores,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      message: json['message'],
      activatedStores: (json['activatedStores'] as List<dynamic>)
          .map((store) => Store.fromJson(store as Map<String, dynamic>))
          .toList(),
      deactivatedStores: (json['deactivatedStores'] as List<dynamic>)
          .map((store) => Store.fromJson(store as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Store {
  final int storeId;
  final String storeName;
  final String storePhoneNumber;
  final String storeArea;
  final String storeEmirate;
  final int createdBy;
  final bool isActive;

  Store({
    required this.storeId,
    required this.storeName,
    required this.storePhoneNumber,
    required this.storeArea,
    required this.storeEmirate,
    required this.createdBy,
    required this.isActive,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['store_id'],
      storeName: json['store_name'],
      storePhoneNumber: json['store_phonenumber'],
      storeArea: json['store_area'],
      storeEmirate: json['store_emirate'],
      createdBy: json['created_by'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'store_phonenumber': storePhoneNumber,
      'store_area': storeArea,
      'store_emirate': storeEmirate,
      'created_by': createdBy,
      'is_active': isActive,
    };
  }
}
