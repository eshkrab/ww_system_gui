import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';

class PlayerProvider extends ChangeNotifier {
  late Player _player;
  PlayerApiService _apiService;
  AppSettings appSettings;

  PlayerProvider({required this.appSettings, required Player player})
      : _apiService = PlayerApiService(appSettings: appSettings),
        _player = player;

  // PlayerProvider({required AppSettings appSettings, required Player player})
  //     : _apiService = PlayerApiService(appSettings: appSettings),
  //       _player = player;

  Player get player => _player;

  void updateAppSettings(AppSettings _appSettings) {
    appSettings = _appSettings;
    _apiService = PlayerApiService(
        appSettings:
            appSettings); // Create new instance of API Service with updated settings
    notifyListeners();
  }

  void updatePlayerState(String state) {
    _player.state = state;
    notifyListeners();
  }

  Future<bool> _updatePlayerStateAndNotify(String state) async {
    try {
      bool success = await _apiService.setState(state);
      if (success) {
        _player = _player.copyWith(state: state);
        await fetchPlayerState(); // Query the API endpoint for player state
        notifyListeners();
        return true;
      } else {
        print('Failed to set player state');
        return false;
      }
    } catch (e) {
      print('Failed to set player state: $e');
      return false;
    }
  }

  Future<bool> stop() async {
    return _updatePlayerStateAndNotify('stop');
  }

  Future<bool> play() async {
    return _updatePlayerStateAndNotify('play');
  }

  Future<bool> pause() async {
    return _updatePlayerStateAndNotify('pause');
  }

  Future<bool> next() async {
    return _updatePlayerStateAndNotify('next');
  }

  Future<bool> previous() async {
    return _updatePlayerStateAndNotify('prev');
  }

  Future<bool> restart() async {
    return _updatePlayerStateAndNotify('restart');
  }

  Future<bool> fetchPlayerState() async {
    try {
      final String state = await _apiService.getState();
      _player = _player.copyWith(state: state);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to fetch player state: $e');
      return false;
    }
  }

  Future<bool> fetchPlayerBrightness() async {
    try {
      final double brightness = await _apiService.getBrightness();
      _player = _player.copyWith(brightness: brightness);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to fetch player brightness: $e');
      return false;
    }
  }

  Future<bool> setPlayerBrightness(double brightness) async {
    try {
      bool success = await _apiService.setBrightness(brightness);
      if (success) {
        _player = _player.copyWith(brightness: brightness);
        await fetchPlayerBrightness(); // Query the API endpoint for brightness
        notifyListeners();
        return true;
      } else {
        print('Failed to set player brightness');
        return false;
      }
    } catch (e) {
      print('Failed to set player brightness: $e');
      return false;
    }
  }

  Future<bool> fetchPlayerFPS() async {
    try {
      final double fps = await _apiService.getFPS();
      _player = _player.copyWith(fps: fps);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to fetch player FPS: $e');
      return false;
    }
  }

  Future<bool> setPlayerFPS(double fps) async {
    try {
      bool success = await _apiService.setFPS(fps);
      if (success) {
        _player = _player.copyWith(fps: fps);
        await fetchPlayerFPS(); // Query the API endpoint for FPS
        notifyListeners();
        return true;
      } else {
        print('Failed to set player FPS');
        return false;
      }
    } catch (e) {
      print('Failed to set player FPS: $e');
      return false;
    }
  }
}
