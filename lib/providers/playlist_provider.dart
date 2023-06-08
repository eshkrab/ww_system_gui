import 'package:flutter/foundation.dart';
import '../models/playlist.dart';
import '../models/app_settings.dart';
import '../models/media.dart';
import '../services/api_service.dart';

class PlaylistProvider extends ChangeNotifier {
  Playlist _playlist;
  AppSettings appSettings;
  PlaylistApiService _apiService;

  PlaylistProvider({
    required AppSettings appSettings,
    required Playlist playlist,
  })  : appSettings = appSettings,
        _apiService = PlaylistApiService(appSettings: appSettings),
        _playlist = playlist;

  Playlist get playlist => _playlist;

  void updateAppSettings(AppSettings _appSettings) {
    appSettings = _appSettings;
    _apiService = PlaylistApiService(appSettings: appSettings);
    notifyListeners();
  }

  Future<void> fetchPlaylist() async {
    try {
      _playlist = await _apiService.fetchPlaylist();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch playlist: $e');
    }
  }

  Future<void> savePlaylist() async {
    try {
      await _apiService.savePlaylist(_playlist);
      notifyListeners();
    } catch (e) {
      print('Failed to save playlist: $e');
    }
  }

  void toggleMode() {
    String currentMode = _playlist.mode;
    String newMode;

    switch (currentMode) {
      case 'repeat':
        newMode = 'repeat_one';
        break;
      case 'repeat_one':
        newMode = 'repeat_none';
        break;
      case 'repeat_none':
      default:
        newMode = 'repeat';
        break;
    }

    _playlist = _playlist.copyWith(mode: newMode);
    savePlaylist();
  }

  void addItem(MediaFile file) {
    _playlist.playlist.add(file);
    notifyListeners();
  }

  void deleteItem(int index) {
    _playlist.playlist.removeAt(index);
    notifyListeners();
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MediaFile item = _playlist.playlist.removeAt(oldIndex);
    _playlist.playlist.insert(newIndex, item);
    notifyListeners();
  }
}
