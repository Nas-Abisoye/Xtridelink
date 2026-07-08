import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import '../../../core/services/storage/index.dart';

@Injectable()
class SettingsCubit extends Cubit<SettingsState> {
  final StorageServiceImpl storageServiceImpl;
  SettingsCubit({required this.storageServiceImpl})
      : super(SettingsState(
            recentLocations: [],
            email: '',
            password: '',
            biometricsLogin: false,
            useEnglish: true));

  void _emitState() {
    emit(SettingsState(
        recentLocations: state.recentLocations,
        email: state.email,
        password: state.password,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void loadSettings() async {
    SettingsState settings = await storageServiceImpl.getSettings();
    emit(settings);
  }

  void toggleBiometricsLogin(bool value) {
    state.biometricsLogin = value;
    _emitState();
    storageServiceImpl.setSettings(state);
  }

  void setUseEnglish(bool value) {
    if (state.useEnglish == value) return;
    state.useEnglish = value;
    _emitState();
    storageServiceImpl.setSettings(state);
  }

  void saveLoginDet({required String email, required String password}) {
    state.email = email;
    state.password = password;
    _emitState();
    storageServiceImpl.setSettings(SettingsState(
        email: email,
        password: password,
        recentLocations: state.recentLocations,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void addRecentLocation(RecentLocationData recentLocation) {
    if (state.recentLocations
        .any((element) => element.address == recentLocation.address)) return;
    state.recentLocations = [recentLocation, ...state.recentLocations];
    _emitState();
    storageServiceImpl.setSettings(SettingsState(
        email: state.email,
        password: state.password,
        recentLocations: state.recentLocations,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void deleteRecentLocation(int index) {
    state.recentLocations.removeAt(index);
    _emitState();
    storageServiceImpl.setSettings(SettingsState(
        email: state.email,
        password: state.password,
        recentLocations: state.recentLocations,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void clearSettings() {
    emit(SettingsState(
        email: '',
        password: '',
        biometricsLogin: false,
        useEnglish: true,
        recentLocations: []));
    storageServiceImpl.setSettings(SettingsState(
        email: '',
        password: '',
        biometricsLogin: false,
        useEnglish: true,
        recentLocations: []));
  }
}
