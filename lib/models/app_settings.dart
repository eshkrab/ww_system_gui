class AppSettings {
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
    // notifyListeners();
  }

  void updateServerIP(String ip) {
    _serverIP = ip;
    // notifyListeners();
  }

  void updateServerPort(int port) {
    _serverPort = port;
    // notifyListeners();
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
