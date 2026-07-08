class LoginParams {
  String? email;
  String? password;

  LoginParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
