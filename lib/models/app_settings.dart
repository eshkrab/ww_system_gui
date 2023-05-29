class AppSettings {
  bool isDarkModeEnabled = true;
  String serverIP = '192.168.86.144';
  int serverPort = 8000;

  AppSettings({
    required this.isDarkModeEnabled,
    required this.serverIP,
    required this.serverPort,
  });

  AppSettings.fromJson(Map<String, dynamic> json) {
    isDarkModeEnabled = json['isDarkModeEnabled'];
    serverIP = json['serverIP'];
    serverPort = json['serverPort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDarkModeEnabled'] = this.isDarkModeEnabled;
    data['serverIP'] = this.serverIP;
    data['serverPort'] = this.serverPort;
    return data;
  }
}
