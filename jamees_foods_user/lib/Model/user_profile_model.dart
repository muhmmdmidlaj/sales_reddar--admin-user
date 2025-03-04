class User {
  final String userName;
  final String userPhone;
  final String userEmail;

  User({
    required this.userName,
    required this.userPhone,
    required this.userEmail,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['user_name'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userEmail: json['user_email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_phone': userPhone,
      'user_email': userEmail,
    };
  }
}
