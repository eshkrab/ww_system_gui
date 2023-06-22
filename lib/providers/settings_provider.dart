import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';
import '../providers/media_provider.dart';
import '../providers/player_provider.dart';
import '../providers/playlist_provider.dart';

class AppSettingsProvider extends ChangeNotifier {
  AppSettings _appSettings;
  SettingsApiService _apiService;
  final MediaFileProvider mediaProvider;
  final PlayerProvider playerProvider;
  final PlaylistProvider playlistProvider;

  AppSettingsProvider(
      {required AppSettings appSettings,
      required this.mediaProvider,
      required this.playerProvider,
      required this.playlistProvider})
      : _appSettings = appSettings,
        _apiService = SettingsApiService(appSettings: appSettings);

  AppSettings get appSettings => _appSettings;

  void updateServerIP(String serverIP) {
    _appSettings = _appSettings.copyWith(serverIP: serverIP);
    _updateAppSettings();
    notifyListeners();
  }

  void updateServerPort(int serverPort) {
    _appSettings = _appSettings.copyWith(serverPort: serverPort);
    _updateAppSettings();
    notifyListeners();
  }

  void updateServerSettings({String? serverIP, int? serverPort}) {
    _appSettings =
        _appSettings.copyWith(serverIP: serverIP, serverPort: serverPort);
    _updateAppSettings();
    notifyListeners();
  }

  void toggleDarkMode() {
    _appSettings = _appSettings.copyWith(
        isDarkModeEnabled: !_appSettings.isDarkModeEnabled);
    _updateAppSettings();
    notifyListeners();
  }

  Future<void> _updateAppSettings() async {
    mediaProvider.updateAppSettings(_appSettings);
    playlistProvider.updateAppSettings(_appSettings);
    playerProvider.updateAppSettings(_appSettings);
  }

  Future<void> fetchNodes() async {
    try {
      final nodesMap = await _apiService.fetchNodes();
      final nodeList =
          nodesMap.entries.map((entry) => Node.fromJson(entry.value)).toList();
      _appSettings = _appSettings.copyWith(serverNodes: nodeList);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch nodes: $e');
    }
  }
}
