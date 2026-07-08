class LoginParams {
  String? phoneNumber;
  String? password;

  LoginParams({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'phone_number': phoneNumber, 'password': password};
  }
}
