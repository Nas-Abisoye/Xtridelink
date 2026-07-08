import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/base/base_cubit.dart';
import 'package:xtridelink/core/base/base_state.dart';
import 'package:xtridelink/core/base/process_state.dart';
import 'package:xtridelink/core/helpers/input/input.dart';
import 'package:xtridelink/domain/params/register_params.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';

part 'signup_state.dart';

@Injectable()
class SignupCubit extends BaseCubit<SignupState> {
  SignupCubit(this._authRepository) : super(SignupState.initial());

  final AuthenticationRepository _authRepository;

  void onPhoneChanged(String phone) {
    emit(state.copyWith(
        formData: state.formData.copyWith(phone: PhoneInput.dirty(phone))));
  }

  void onOtpChanged(String otp) {
    emit(state.copyWith(
        formData: state.formData.copyWith(otp: OtpInput.dirty(otp))));
  }

  void onFirstNameChanged(String firstName) {
    emit(state.copyWith(
        formData:
            state.formData.copyWith(firstName: NameInput.dirty(firstName))));
  }

  void onLastNameChanged(String lastName) {
    emit(state.copyWith(
        formData:
            state.formData.copyWith(lastName: NameInput.dirty(lastName))));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(
        formData: state.formData.copyWith(email: EmailInput.dirty(email))));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(
        formData: state.formData.copyWith(
            password: PasswordInput.dirty(pinLenght: 6, value: password))));
  }

  void onConfirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(
        formData: state.formData.copyWith(
            confirmPassword: ConfirmPasswordInput.dirty(
                state.formData.password, confirmPassword))));
  }

  Future<void> initiateSignup() async {
    launchApiCall(
      () => _authRepository.initiateRegistration(state.formData.phone.value),
      doOnSuccess: (response) {
        emit(state.copyWith(
            initiatSignupResponse:
                ProcessState.success(response.message ?? '')));
      },
      showLoading: true,
      doOnError: (error) {
        emit(state.copyWith(initiatSignupResponse: ProcessState.error(error)));
      },
      doOnLoading: () {
        emit(state.copyWith(
            initiatSignupResponse: const ProcessState.loading()));
      },
    );
  }

  Future<void> verifyPhone({required String phone, required String otp}) async {
    launchApiCall(
      () => _authRepository.verifyPhonenumber(phone: phone, otp: otp),
      doOnSuccess: (response) {
        emit(state.copyWith(
          verifyOtpResponse: ProcessState.success(response.message ?? ''),
        ));
      },
      showLoading: true,
      doOnError: (error) {
        emit(state.copyWith(
          verifyOtpResponse: ProcessState.error(error),
        ));
      },
      doOnLoading: () {
        emit(state.copyWith(
          verifyOtpResponse: const ProcessState.loading(),
        ));
      },
    );
  }

  Future<void> completeRegistration(String phone) async {
    final params = RegisterParams(
      userType: 'customer',
      firstName: state.formData.firstName.value,
      lastName: state.formData.lastName.value,
      email: state.formData.email.value,
      password: state.formData.password.value,
      confirmPassword: state.formData.password.value,
      phoneNumber: phone,
      location: 'Nigeria',
    );
    launchApiCall(
      () => _authRepository.completeRegistration(params),
      doOnSuccess: (response) {
        emit(state.copyWith(
          createUserResponse: ProcessState.success(response.message!),
        ));
      },
      showLoading: true,
      doOnError: (error) {
        emit(state.copyWith(
          createUserResponse: ProcessState.error(error),
        ));
      },
      doOnLoading: () {
        emit(state.copyWith(
          createUserResponse: const ProcessState.loading(),
        ));
      },
    );
  }

  Future<bool> resendOtp() async {
    return false;
  }
}
