import 'package:flutter/material.dart';
import 'package:trophy_gui/services/api_service.dart';
import 'package:trophy_gui/models/media.dart';

class MediaViewModel extends ChangeNotifier {
  final MediaApiService _mediaApiService;
  List<Media> mediaList = [];

  MediaViewModel({required MediaApiService mediaApiService})
      : _mediaApiService = mediaApiService;

  Future<void> fetchMedia() async {
    List<String> media = await _mediaApiService.fetchMediaDirectory();
    mediaList = media.map((m) => Media(filename: m)).toList();
    notifyListeners();
  }

  Future<bool> uploadMedia() async {
    bool success = await _mediaApiService.uploadMedia();
    if (success) {
      await fetchMedia();
    }
    return success;
  }

  Future<void> deleteMedia(String filename) async {
    await _mediaApiService.deleteMedia(filename);
    await fetchMedia();
  }
}
