import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/player.dart';
import '../models/playlist.dart';
import '../models/media.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';

class PlayerProvider extends ChangeNotifier {
  late Player _player;
  PlayerApiService _apiService;
  PlaylistApiService _playlistApiService;
  AppSettings appSettings;

  PlayerProvider({required this.appSettings, required Player player})
      : _apiService = PlayerApiService(appSettings: appSettings),
        _playlistApiService = PlaylistApiService(appSettings: appSettings),
        _player = player;

  Player get player => _player;

  // Create a method to update the API service instances with the updated AppSettings
  void updateAppSettings(AppSettings newSettings) {
    // Set the new AppSettings
    _appSettings = newSettings;

    // Create new instances of API service with the updated settings
    _apiService = PlayerApiService(appSettings: newSettings);
    _playlistApiService = PlaylistApiService(appSettings: newSettings);

    // Call methods that use the updated API services
    fetchPlayerState();
    fetchPlayerBrightness();
    fetchPlayerFPS();

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
        // _player = _player.copyWith(state: state);
        await fetchPlayerState(); // Query the API endpoint for player state
        // notifyListeners();
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

  String getState() {
    return _player.state;
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

  Future<bool> fetchCurrentMediaFile() async {
    try {
      // final String currentMediaFileString =
      //     await _apiService.getCurrentMediaFile();
      //
      // final MediaFile currentMediaFile = MediaFile(
      //     name: currentMediaFileString, filepath: currentMe
      // print('Current media file string: $currentMediaFileString');

      //get media file by using media file from json and api call getcurrentmediafile
      final String currentMediaFileString =
          await _apiService.getCurrentMediaFile();
      print('Current media file string: $currentMediaFileString');
      Map<String, dynamic> json = jsonDecode(currentMediaFileString);

      final MediaFile mediafile =
          MediaFile.fromJson(json); //get media file from json

      //search through the playlist and find the current media file by name
      final Playlist playlist = await _playlistApiService.fetchPlaylist();
      final MediaFile currentMediaFile = playlist.playlist.firstWhere(
          (mediaFile) => mediaFile.name == currentMediaFileString,
          orElse: () => MediaFile(name: 'none', filepath: 'none'));

      print('Current media file: ${currentMediaFile.name}');
      // final MediaFile currentMediaFile =
      //     await _apiService.getCurrentMediaFile();
      _player = _player.copyWith(currentMediaFile: currentMediaFile);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to fetch current media file: $e');
      return false;
    }
  }

  //fetch thumbnail url for current media file
  Future<String> fetchCurrentMediaFileThumbnailUrl() async {
    try {
      final String currentMediaFileString =
          await _apiService.getCurrentMediaFile();
      final String thumbnailUrl =
          await _apiService.getCurrentThumbnailUrl(currentMediaFileString);
      return thumbnailUrl;
    } catch (e) {
      print('Failed to fetch current media file thumbnail url: $e');
      return '';
    }
  }
}
