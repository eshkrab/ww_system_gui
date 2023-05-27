import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../models/media.dart';

class PlayerViewModel extends ChangeNotifier {
  final PlayerApiService _playerApiService;
  Player player = Player(
      playlist: [],
      state: 'stopped',
      mode: 'normal',
      brightness: 0.0,
      fps: 0.0);

  List<Media> mediaItems = []; // Mock your media items here.
  bool isEditMode = false; // Track if we're in edit mode or not

  PlayerViewModel({required PlayerApiService playerApiService})
      : _playerApiService = playerApiService;

  Future<void> fetchStateAndMode() async {
    String state = await _playerApiService.getState();
    String mode = await _playerApiService.getMode();
    List<String> playlist = await _playerApiService.fetchPlaylist();
    double brightness = await _playerApiService.getBrightness();
    double fps = await _playerApiService.getFPS();

    player = Player(
      playlist: playlist.map((m) => Media(filename: m)).toList(),
      state: state,
      mode: mode,
      brightness: brightness,
      fps: fps,
    );

    notifyListeners();
  }

  Future<void> setState(String value) async {
    await _playerApiService.setState(value);
    fetchStateAndMode();
  }

  Future<void> setMode(String value) async {
    await _playerApiService.setMode(value);
    fetchStateAndMode();
  }

  Future<void> setBrightness(double value) async {
    await _playerApiService.setBrightness(value);
    fetchStateAndMode();
  }

  Future<void> setFPS(double value) async {
    await _playerApiService.setFPS(value);
    fetchStateAndMode();
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditMode = !isEditMode;
    notifyListeners();
  }

  // Add media item to playlist
  void addMediaItemToPlaylist(int index) {
    player.playlist.add(mediaItems[index]);
    // If your service has a method to update playlist, call here.
    notifyListeners();
  }

  // Delete media item from playlist
  void deletePlaylistItem(int index) {
    player.playlist.removeAt(index);
    // If your service has a method to update playlist, call here.
    notifyListeners();
  }

  // Move media item within playlist
  void movePlaylistItem(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // newIndex -= 1; // uncomment this if you're intending to use Drag&Drop. 
    }
    final Media item = player.playlist.removeAt(oldIndex);
    player.playlist.insert(newIndex, item);
    // If your service has a method to update playlist, call here.
    notifyListeners();
  }
}

