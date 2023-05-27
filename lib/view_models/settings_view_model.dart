import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  AppSettings appSettings = AppSettings(
    isDarkModeEnabled: true,
    serverIP: '',
    serverPort: 0,
  );

  void updateSettings(AppSettings newSettings) {
    appSettings = newSettings;
    notifyListeners();
  }

  void toggleDarkMode() {
    appSettings.isDarkModeEnabled = !appSettings.isDarkModeEnabled;
    notifyListeners();
  }

  void updateServerIP(String newIP) {
    appSettings.serverIP = newIP;
    notifyListeners();
  }

  void updateServerPort(int newPort) {
    appSettings.serverPort = newPort;
    notifyListeners();
  }
}
