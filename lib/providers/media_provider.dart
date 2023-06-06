import 'package:flutter/foundation.dart';
import '../models/media.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';

class MediaFileProvider extends ChangeNotifier {
  List<MediaFile> _mediaFiles = [];
  final MediaApiService _apiService;

  MediaFileProvider({required AppSettings appSettings})
      : _apiService = MediaApiService(appSettings: appSettings);

  List<MediaFile> get mediaFiles => _mediaFiles;

  Future<void> fetchMediaFiles() async {
    try {
      List<String> mediaNames = await _apiService.fetchMediaDirectory();
      _mediaFiles = mediaNames
          .map((name) => MediaFile(name: name, filepath: ''))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch media files: $e');
    }
  }

  Future<void> uploadMedia() async {
    try {
      bool success = await _apiService.uploadMedia();
      if (success) {
        fetchMediaFiles(); // refresh media files after successful upload
      } else {
        print('Failed to upload media file');
      }
    } catch (e) {
      print('Error in uploading media: $e');
    }
  }

  Future<void> deleteMedia(String filename) async {
    try {
      await _apiService.deleteMedia(filename);
      fetchMediaFiles(); // refresh media files after successful deletion
    } catch (e) {
      print('Failed to delete media file: $e');
    }
  }
}
