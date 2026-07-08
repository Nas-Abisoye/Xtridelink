class RegisterParams {
  String? userType;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? password;
  String? confirmPassword;
  String? location;

  RegisterParams({
    this.userType,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.password,
    this.confirmPassword,
    this.location,
  });

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['user_type'] = userType;
    data['phone_number'] = phoneNumber;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['location'] = location;

    return data;
  }
}
