import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/base/base_cubit.dart';
import 'package:xtridelink/core/base/base_state.dart';
import 'package:xtridelink/core/base/process_state.dart';
import 'package:xtridelink/core/helpers/input/input.dart';
import 'package:xtridelink/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink/domain/params/login_params.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';

part 'login_state.dart';

@Injectable()
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(LoginState.initial());

  final AuthenticationRepository _authenticationRepository;

  void onPhoneChanged(String value) {
    emit(state.copyWith(email: PhoneInput.dirty(value)));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: PasswordInput.dirty(value: value)));
  }

  Future<void> signIn() async {
    final params = LoginParams(
      phoneNumber: state.phone.value,
      password: state.password.value,
    );
    launchApiCall(
      () => _authenticationRepository.login(params),
      showLoading: true,
      doOnLoading: () =>
          emit(state.copyWith(loginResponse: ProcessState.loading())),
      doOnError: (error) =>
          emit(state.copyWith(loginResponse: ProcessState.error(error))),
      doOnSuccess: (data) =>
          emit(state.copyWith(loginResponse: ProcessState.success(data))),
    );
  }
}
