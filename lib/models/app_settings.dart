import 'package:flutter/foundation.dart';

class AppSettings with ChangeNotifier {
  bool _isDarkModeEnabled = true;
  String _serverIP = '192.168.86.144';
  int _serverPort = 8080;

  bool get isDarkModeEnabled => _isDarkModeEnabled;
  String get serverIP => _serverIP;
  int get serverPort => _serverPort;

  AppSettings({
    required bool isDarkModeEnabled,
    required String serverIP,
    required int serverPort,
  })  : _isDarkModeEnabled = isDarkModeEnabled,
        _serverIP = serverIP,
        _serverPort = serverPort;

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }

  void updateServerIP(String ip) {
    _serverIP = ip;
    notifyListeners();
  }

  void updateServerPort(int port) {
    _serverPort = port;
    notifyListeners();
  }

  AppSettings copyWith({
    String? serverIP,
    int? serverPort,
    bool? isDarkModeEnabled,
  }) {
    return AppSettings(
      serverIP: serverIP ?? this.serverIP,
      serverPort: serverPort ?? this.serverPort,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
    );
  }

  AppSettings.fromJson(Map<String, dynamic> json) {
    _isDarkModeEnabled = json['isDarkModeEnabled'];
    _serverIP = json['serverIP'];
    _serverPort = json['serverPort'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkModeEnabled': _isDarkModeEnabled,
      'serverIP': _serverIP,
      'serverPort': _serverPort,
    };
  }
}

// class AppSettings {
//   bool isDarkModeEnabled = true;
//   String serverIP = '192.168.86.144';
//   int serverPort = 8080;
//
//   AppSettings({
//     required this.isDarkModeEnabled,
//     required this.serverIP,
//     required this.serverPort,
//   });
//
//   AppSettings.fromJson(Map<String, dynamic> json) {
//     isDarkModeEnabled = json['isDarkModeEnabled'];
//     serverIP = json['serverIP'];
//     serverPort = json['serverPort'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['isDarkModeEnabled'] = this.isDarkModeEnabled;
//     data['serverIP'] = this.serverIP;
//     data['serverPort'] = this.serverPort;
//     return data;
//   }
// }
