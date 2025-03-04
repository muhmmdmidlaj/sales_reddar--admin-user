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

  // Factory constructor to convert JSON to Store model
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
}
