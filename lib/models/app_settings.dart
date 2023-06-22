class Node {
  final String? ip;
  final String? hostname;

  Node._({this.ip, this.hostname});

  factory Node({String? ip, String? hostname}) {
    if (ip == null && hostname == null) {
      throw ArgumentError("Either ip or hostname must be provided");
    }
    return Node._(ip: ip, hostname: hostname);
  }

  // Deserialize from Map
  factory Node.fromMap(Map<String, dynamic> nodeData, String ip) {
    return Node(ip: ip, hostname: nodeData['hostname']);
  }

  // Deserialize from JSON
  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(ip: json['ip'], hostname: json['hostname']);
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() => {'ip': ip, 'hostname': hostname};

  // copyWith method
  Node copyWith({String? ip, String? hostname}) {
    return Node(
      ip: ip ?? this.ip,
      hostname: hostname ?? this.hostname,
    );
  }
}

class AppSettings {
  bool _isDarkModeEnabled = true;
  String _serverIP = '192.168.86.144';
  int _serverPort = 8080;
  List<Node> _serverNodes;

  bool get isDarkModeEnabled => _isDarkModeEnabled;
  String get serverIP => _serverIP;
  int get serverPort => _serverPort;
  List<Node> get serverNodes => _serverNodes;

  AppSettings({
    required bool isDarkModeEnabled,
    required String serverIP,
    required int serverPort,
  })  : _isDarkModeEnabled = isDarkModeEnabled,
        _serverIP = serverIP,
        _serverPort = serverPort,
        _serverNodes = [Node(ip: serverIP)];

  // Function to parse nodes list JSON
  void setServerNodesFromJson(Map<String, dynamic> json) {
    _serverNodes = [];
    json.forEach((key, value) {
      _serverNodes.add(Node.fromMap(value, key));
    });
  }

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
    List<Node>? serverNodes,
  }) {
    return AppSettings(
      serverIP: serverIP ?? this.serverIP,
      serverPort: serverPort ?? this.serverPort,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
    ).._serverNodes = serverNodes ?? this._serverNodes;
  }

  AppSettings.fromJson(Map<String, dynamic> json)
      : _isDarkModeEnabled = json['isDarkModeEnabled'],
        _serverIP = json['serverIP'],
        _serverPort = json['serverPort'],
        _serverNodes = [Node(ip: json['serverIP'])] {
    // Empty body for constructor
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkModeEnabled': _isDarkModeEnabled,
      'serverIP': _serverIP,
      'serverPort': _serverPort,
      // 'serverNodes': _serverNodes.map((node) => node.toJson()).toList(),
    };
  }

  /// Returns a list of all available node names from `_serverNodes`.
  List<String> getNodeNames() {
    return _serverNodes.map((node) => node.hostname ?? node.ip!).toList();
  }
}
