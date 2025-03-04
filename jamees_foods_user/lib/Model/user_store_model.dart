class UserStoreData {
  final String message;
  final List<GetStore> stores;

  UserStoreData({
    required this.message,
    required this.stores,
  });

  factory UserStoreData.fromJson(Map<String, dynamic> json) {
    return UserStoreData(
      message: json['message'],
      stores:
          List<GetStore>.from(json['stores'].map((x) => GetStore.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "stores": stores.map((x) => x.toJson()).toList(),
    };
  }
}

class GetStore {
  final int storeId;
  final String storeName;
  final String storePhoneNumber;
  final String storeArea;
  final String storeEmirate;
  final int createdBy;
  final bool isActive;

  GetStore({
    required this.storeId,
    required this.storeName,
    required this.storePhoneNumber,
    required this.storeArea,
    required this.storeEmirate,
    required this.createdBy,
    required this.isActive,
  });

  factory GetStore.fromJson(Map<String, dynamic> json) {
    return GetStore(
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
      "store_id": storeId,
      "store_name": storeName,
      "store_phonenumber": storePhoneNumber,
      "store_area": storeArea,
      "store_emirate": storeEmirate,
      "created_by": createdBy,
      "is_active": isActive,
    };
  }
}
