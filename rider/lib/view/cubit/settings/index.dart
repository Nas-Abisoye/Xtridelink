import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink_driver/domain/model/local/settings.dart';
import '../../../core/services/storage/index.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final StorageServiceImpl storageServiceImpl;
  SettingsCubit({required this.storageServiceImpl})
      : super(SettingsState(
            recentLocations: [],
            phoneNumber: '',
            password: '',
            biometricsLogin: false,
            useEnglish: true));

  void _emitState() {
    emit(SettingsState(
        recentLocations: state.recentLocations,
        phoneNumber: state.phoneNumber,
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

  void saveLoginDet({required String phoneNumber, required String password}) {
    state.phoneNumber = phoneNumber;
    state.password = password;
    _emitState();
    storageServiceImpl.setSettings(SettingsState(
        phoneNumber: phoneNumber,
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
        phoneNumber: state.phoneNumber,
        password: state.password,
        recentLocations: state.recentLocations,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void deleteRecentLocation(int index) {
    state.recentLocations.removeAt(index);
    _emitState();
    storageServiceImpl.setSettings(SettingsState(
        phoneNumber: state.phoneNumber,
        password: state.password,
        recentLocations: state.recentLocations,
        biometricsLogin: state.biometricsLogin,
        useEnglish: state.useEnglish));
  }

  void clearSettings() {
    emit(SettingsState(
        phoneNumber: '',
        password: '',
        biometricsLogin: false,
        useEnglish: true,
        recentLocations: []));
    storageServiceImpl.setSettings(SettingsState(
        phoneNumber: '',
        password: '',
        biometricsLogin: false,
        useEnglish: true,
        recentLocations: []));
  }
}
