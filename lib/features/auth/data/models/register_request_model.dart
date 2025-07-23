class RegisterRequestModel {
  final String email;
  final String name;
  final String password;

  const RegisterRequestModel({
    required this.email,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }
} 