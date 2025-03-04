import 'dart:convert';

class EachUserResponse {
  final String message;
  final EachUser user;
  final List<Visit> visits;

  EachUserResponse({
    required this.message,
    required this.user,
    required this.visits,
  });

  factory EachUserResponse.fromJson(Map<String, dynamic> json) {
    return EachUserResponse(
      message: json['message'] ?? '',
      user: EachUser.fromJson(json['user']),
      visits: json['visits'] != null
          ? List<Visit>.from(json['visits'].map((x) => Visit.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'visits': visits.map((x) => x.toJson()).toList(),
    };
  }
}

class EachUser {
  final int userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userRole;
  final bool isActive;

  EachUser({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userRole,
    required this.isActive,
  });

  factory EachUser.fromJson(Map<String, dynamic> json) {
    return EachUser(
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userRole: json['user_role'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'user_role': userRole,
      'is_active': isActive,
    };
  }
}

class Visit {
  final int visitId;
  final int userId;
  final int storeId;
  final String storeName;
  final DateTime checkinTime;
  final DateTime? checkoutTime;
  final double salesAmount;

  Visit({
    required this.visitId,
    required this.userId,
    required this.storeId,
    required this.storeName,
    required this.checkinTime,
    this.checkoutTime,
    required this.salesAmount,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      visitId: json['visit_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      storeId: json['store_id'] ?? 0,
      storeName: json['store_name'] ?? '',
      checkinTime: DateTime.parse(json['checkin_Time']),
      checkoutTime: json['checkout_Time'] != null
          ? DateTime.tryParse(json['checkout_Time'])
          : null,
      salesAmount: double.tryParse(json['sales_Amount'] ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_id': visitId,
      'user_id': userId,
      'store_id': storeId,
      'store_name': storeName,
      'checkin_Time': checkinTime.toIso8601String(),
      'checkout_Time': checkoutTime?.toIso8601String(),
      'sales_Amount': salesAmount.toString(),
    };
  }
}

EachUserResponse userResponseFromJson(String str) =>
    EachUserResponse.fromJson(json.decode(str));

String userResponseToJson(EachUserResponse data) => json.encode(data.toJson());
