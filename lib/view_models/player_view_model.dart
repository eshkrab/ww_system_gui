import 'package:flutter/material.dart';
import 'package:trophy_gui/view_models/playlist_view_model.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../models/media.dart';
import '../models/app_settings.dart';
import '../view_models/playlist_view_model.dart';

class PlayerViewModel extends ChangeNotifier {
  final PlayerApiService _playerApiService;
  final SettingsApiService _settingsApiService;

  bool isEditMode = false; // Track if we're in edit mode or not

  Player player = Player(state: 'stopped', brightness: 0.0, fps: 0.0);

  // List<MediaFile> mediaItems = []; // Mock your media items here.

  PlayerViewModel({required AppSettings settings})
      : _playerApiService = PlayerApiService(appSettings: settings),
        _settingsApiService = SettingsApiService(appSettings: settings);

  Future<bool> next() async {
    bool success = await _playerApiService.setState('next');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<bool> previous() async {
    bool success = await _playerApiService.setState('prev');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<bool> play() async {
    bool success = await _playerApiService.setState('play');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<bool> pause() async {
    bool success = await _playerApiService.setState('pause');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<bool> stop() async {
    bool success = await _playerApiService.setState('stop');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<bool> restart() async {
    bool success = await _playerApiService.setState('restart');
    fetchState();
    notifyListeners();
    return success;
  }

  Future<void> fetchState() async {
    String state = await _playerApiService.getState();
    // String mode = await _playerApiService.getMode();
    // List<String> playlist = await _playlistApiService.fetchPlaylist();
    double brightness = await _settingsApiService.getBrightness();
    double fps = await _settingsApiService.getFPS();

    player = Player(
      // playlist: playlist.map((m) => MediaFile(filename: m)).toList(),
      state: state,
      brightness: brightness,
      fps: fps,
    );

    notifyListeners();
  }

  Future<void> setState(String value) async {
    await _playerApiService.setState(value);
    getState();
    notifyListeners();
  }

  Future<String> getState() async {
    String state = await _playerApiService.getState();
    return state;
  }

  Future<void> setBrightness(double value) async {
    bool success = await _settingsApiService.setBrightness(value);
    if (!success) {
      throw Exception('Failed to set brightness');
    }
    getBrightness();
    notifyListeners();
  }

  Future<double> getBrightness() async {
    double brightness = await _settingsApiService.getBrightness();
    notifyListeners();
    return brightness;
  }

  Future<void> setFPS(double value) async {
    await _settingsApiService.setFPS(value);
    getFPS();
    notifyListeners();
  }

  Future<double> getFPS() async {
    double fps = await _settingsApiService.getFPS();
    notifyListeners();
    return fps;
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditMode = !isEditMode;
    notifyListeners();
  }
}
