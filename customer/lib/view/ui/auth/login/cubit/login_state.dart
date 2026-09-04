part of 'login_cubit.dart';

class LoginState extends BaseState {
  final PhoneInput phone;
  final PasswordInput password;
  final ProcessState<LoginResponse> loginResponse;

  bool get canLogin => Formz.validate([phone, password]) && !isLoading;

  const LoginState._({
    required this.phone,
    required this.password,
    required this.loginResponse,
    super.exception,
    super.isLoading,
  });

  factory LoginState.initial() => LoginState._(
        phone: PhoneInput.pure(),
        password: PasswordInput.pure(),
        loginResponse: ProcessState.init(null),
      );

  @override
  LoginState copyWith({
    PhoneInput? email,
    PasswordInput? password,
    ProcessState<LoginResponse>? loginResponse,
    Exception? exception,
    bool? isLoading,
  }) =>
      LoginState._(
        phone: email ?? phone,
        password: password ?? this.password,
        loginResponse: loginResponse ?? this.loginResponse,
        exception: exception ?? this.exception,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [
        phone,
        password,
        loginResponse,
        exception,
        isLoading,
      ];
}
