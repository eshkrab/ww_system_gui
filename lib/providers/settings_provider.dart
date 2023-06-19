import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';

class AppSettingsProvider extends ChangeNotifier {
  AppSettings _appSettings;

  AppSettingsProvider({required AppSettings appSettings})
      : _appSettings = appSettings;

  AppSettings get appSettings => _appSettings;

  void updateServerIP(String serverIP) {
    _appSettings = _appSettings.copyWith(serverIP: serverIP);
    notifyListeners();
  }

  void updateServerPort(int serverPort) {
    _appSettings = _appSettings.copyWith(serverPort: serverPort);
    notifyListeners();
  }

  void updateServerSettings({String? serverIP, int? serverPort}) {
    _appSettings =
        _appSettings.copyWith(serverIP: serverIP, serverPort: serverPort);
    notifyListeners();
  }

  void toggleDarkMode() {
    _appSettings = _appSettings.copyWith(
        isDarkModeEnabled: !_appSettings.isDarkModeEnabled);
    notifyListeners();
  }
}
