class AdminLoginResponse {
  final String message;
  final String token; // Now maps "access_token" instead of "token"
  final Admin admin;

  AdminLoginResponse({
    required this.message,
    required this.token,
    required this.admin,
  });

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponse(
      message: json['message'] ?? 'No message',
      token:
          json['access_token'] ?? '', // Fix: Change 'token' to 'access_token'
      admin: Admin.fromJson(json['admin']),
    );
  }
}

class Admin {
  final int id;
  final String email;
  final String role;

  Admin({
    required this.id,
    required this.email,
    required this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
