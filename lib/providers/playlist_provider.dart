import 'package:flutter/foundation.dart';
import '../models/playlist.dart';
import '../models/app_settings.dart';
import '../models/media.dart';
import '../services/api_service.dart';

class PlaylistProvider extends ChangeNotifier {
  Playlist _playlist;
  final PlaylistApiService _apiService;

  PlaylistProvider(
      {required AppSettings appSettings, required Playlist playlist})
      : _apiService = PlaylistApiService(appSettings: appSettings),
        _playlist = playlist;

  Playlist get playlist => _playlist;

  Future<void> fetchPlaylist() async {
    try {
      final List<String> playlistNames = await _apiService.fetchPlaylist();
      _playlist = Playlist(
        playlist: playlistNames
            .map((name) => MediaFile(name: name, filepath: ''))
            .toList(),
        mode: _playlist.mode,
      );
      notifyListeners();
    } catch (e) {
      print('Failed to fetch playlist: $e');
    }
  }

  Future<void> savePlaylist(List<MediaFile> playlist, String mode) async {
    try {
      await _apiService.savePlaylist(
          playlist.map((mediaFile) => mediaFile.name).toList(), mode);
      _playlist = Playlist(playlist: playlist, mode: mode);
      notifyListeners();
    } catch (e) {
      print('Failed to save playlist: $e');
    }
  }
}
