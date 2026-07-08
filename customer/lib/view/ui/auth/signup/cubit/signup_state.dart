part of 'signup_cubit.dart';

class SignupState extends BaseState {
  final SignUpFormData formData;
  final ProcessState<String> initiatSignupResponse;
  final ProcessState<String> verifyOtpResponse;
  final ProcessState<String> createUserResponse;

  SignupState._({
    required this.formData,
    required this.initiatSignupResponse,
    required this.verifyOtpResponse,
    required this.createUserResponse,
    super.isLoading,
    super.exception,
  });

  factory SignupState.initial() => SignupState._(
        formData: SignUpFormData.empty(),
        initiatSignupResponse: const ProcessState.init(null),
        verifyOtpResponse: const ProcessState.init(null),
        createUserResponse: const ProcessState.init(null),
      );

  @override
  List<Object?> get props => [
        formData,
        initiatSignupResponse,
        verifyOtpResponse,
        createUserResponse,
        isLoading,
        exception,
      ];

  @override
  SignupState copyWith({
    SignUpFormData? formData,
    ProcessState<String>? initiatSignupResponse,
    ProcessState<String>? verifyOtpResponse,
    ProcessState<String>? createUserResponse,
    bool? isLoading,
    Exception? exception,
  }) {
    return SignupState._(
      formData: formData ?? this.formData,
      initiatSignupResponse:
          initiatSignupResponse ?? this.initiatSignupResponse,
      verifyOtpResponse: verifyOtpResponse ?? this.verifyOtpResponse,
      createUserResponse: createUserResponse ?? this.createUserResponse,
      isLoading: isLoading ?? this.isLoading,
      exception: exception ?? this.exception,
    );
  }
}

class SignUpFormData extends Equatable {
  final PhoneInput phone;
  final OtpInput otp;
  final NameInput firstName;
  final NameInput lastName;
  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final StringInput location;

  bool get canInitiateSignup => Formz.validate([phone]);

  bool get canVerifyOtp => Formz.validate([otp]);

  bool get canCreateUser => Formz.validate([
        firstName,
        lastName,
        email,
        password,
      ]);

  const SignUpFormData._({
    required this.phone,
    required this.otp,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.location,
  });

  factory SignUpFormData.empty() => const SignUpFormData._(
        phone: PhoneInput.pure(),
        otp: OtpInput.pure(),
        firstName: NameInput.pure(),
        lastName: NameInput.pure(),
        email: EmailInput.pure(),
        password: PasswordInput.pure(),
        confirmPassword: ConfirmPasswordInput.pure(PasswordInput.pure()),
        location: StringInput.pure(),
      );

  SignUpFormData copyWith({
    PhoneInput? phone,
    OtpInput? otp,
    NameInput? firstName,
    NameInput? lastName,
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    StringInput? location,
  }) {
    return SignUpFormData._(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      location: location ?? this.location,
    );
  }

  @override
  List<Object> get props {
    return [
      phone,
      otp,
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
      location,
    ];
  }
}
