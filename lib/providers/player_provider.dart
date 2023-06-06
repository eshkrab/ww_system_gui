import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';

class PlayerProvider extends ChangeNotifier {
  late Player _player;
  final PlayerApiService _apiService;

  PlayerProvider({required AppSettings appSettings, required Player player})
      : _apiService = PlayerApiService(appSettings: appSettings),
        _player = player;

  Player get player => _player;

  // PlayerProvider() {
  //   _player = Player(
  //     state: '',
  //     brightness: 0.0,
  //     fps: 0.0,
  //   );
  //   _player.addListener(update);
  // }
  // Player get player => _player;

  void updatePlayerState(String state) {
    _player.state = state;
    notifyListeners();
  }

  // void updatePlayerBrightness(double brightness) {
  //   _player.brightness = brightness;
  //   notifyListeners();
  // }
  //
  // void updatePlayerFps(double fps) {
  //   _player.fps = fps;
  //   notifyListeners();
  // }
  //
  // void update() {
  //   notifyListeners();
  // }

  Future<void> fetchPlayerBrightness() async {
    try {
      final double brightness = await _apiService.getBrightness();
      _player = _player.copyWith(brightness: brightness);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch player brightness: $e');
    }
  }

  Future<void> setPlayerBrightness(double brightness) async {
    try {
      bool success = await _apiService.setBrightness(brightness);
      if (success) {
        _player = _player.copyWith(brightness: brightness);
        notifyListeners();
      } else {
        print('Failed to set player brightness');
      }
    } catch (e) {
      print('Failed to set player brightness: $e');
    }
  }

  Future<void> fetchPlayerFPS() async {
    try {
      final double fps = await _apiService.getFPS();
      _player = _player.copyWith(fps: fps);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch player FPS: $e');
    }
  }

  Future<void> setPlayerFPS(double fps) async {
    try {
      bool success = await _apiService.setFPS(fps);
      if (success) {
        _player = _player.copyWith(fps: fps);
        notifyListeners();
      } else {
        print('Failed to set player FPS');
      }
    } catch (e) {
      print('Failed to set player FPS: $e');
    }
  }
}
