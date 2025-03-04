class AdminLogin {
  String email;
  String password;

  AdminLogin({
    required this.email,
    required this.password,
  });

  // Factory method to create an instance from JSON
  factory AdminLogin.fromJson(Map<String, dynamic> json) {
    return AdminLogin(
      email: json['email'],
      password: json['password'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
