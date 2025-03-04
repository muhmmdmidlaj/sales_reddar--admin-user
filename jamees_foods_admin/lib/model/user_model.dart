import 'dart:convert';

class UserResponseModel {
  String message;
  List<UserModel> users;
  List<UserModel> activeSalesmens;
  List<UserModel> deactivateSalesmens;

  UserResponseModel({
    required this.message,
    required this.users,
    required this.activeSalesmens,
    required this.deactivateSalesmens,
  });

  factory UserResponseModel.fromJson(String str) =>
      UserResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserResponseModel.fromMap(Map<String, dynamic> json) =>
      UserResponseModel(
        message: json["message"],
        users: List<UserModel>.from(
            json["users"].map((x) => UserModel.fromMap(x))),
        activeSalesmens: List<UserModel>.from(
            json["activeSalesmens"].map((x) => UserModel.fromMap(x))),
        deactivateSalesmens: List<UserModel>.from(
            json["deactivateSalesmens"].map((x) => UserModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "users": List<dynamic>.from(users.map((x) => x.toMap())),
        "activeSalesmens":
            List<dynamic>.from(activeSalesmens.map((x) => x.toMap())),
        "deactivateSalesmens":
            List<dynamic>.from(deactivateSalesmens.map((x) => x.toMap())),
      };
}

class UserModel {
  int userId;
  String userName;
  String userEmail;
  String userPhone;
  String userPassword;
  String userRole;
  bool isActive;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userPassword,
    required this.userRole,
    required this.isActive,
  });

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        userPassword: json["user_password"],
        userRole: json["user_role"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_phone": userPhone,
        "user_password": userPassword,
        "user_role": userRole,
        "is_active": isActive,
      };
}
