import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../models/playlist.dart';
import '../models/app_settings.dart';
import '../models/media.dart';

class PlaylistViewModel extends ChangeNotifier {
  final PlaylistApiService _playlistApiService;
  Playlist _playlist = Playlist(playlist: [], mode: '');

  PlaylistViewModel({required AppSettings settings})
      : _playlistApiService = PlaylistApiService(appSettings: settings) {
    init();
  }

  Future<void> init() async {
    _playlist.playlist = await fetchPlaylist();
    notifyListeners();
  }

  Future<List<MediaFile>> fetchPlaylist() async {
    final List<String> playlistData = await _playlistApiService.fetchPlaylist();
    return playlistData
        .map((item) => MediaFile.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> savePlaylist(List<MediaFile> playlist, String mode) async {
    final List<String> playlistData =
        playlist.map((item) => jsonEncode(item.toJson())).toList();
    await _playlistApiService.savePlaylist(playlistData, mode);
  }

  // Add media item to playlist
  void addMediaItemToPlaylist(int index) {
    _playlist.playlist.add(_playlist.playlist[index]);
    savePlaylist(_playlist.playlist, _playlist.mode);
    notifyListeners();
  }

  // Delete media item from playlist
  void deletePlaylistItem(int index) {
    _playlist.playlist.removeAt(index);
    savePlaylist(_playlist.playlist, _playlist.mode);
    notifyListeners();
  }

  // Move media item within playlist
  void movePlaylistItem(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MediaFile item = _playlist.playlist.removeAt(oldIndex);
    _playlist.playlist.insert(newIndex, item);
    savePlaylist(_playlist.playlist, _playlist.mode);
    notifyListeners();
  }
}
