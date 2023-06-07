import 'package:flutter/foundation.dart';
import '../models/media.dart';
import '../models/app_settings.dart';
import '../services/api_service.dart';

class MediaFileProvider extends ChangeNotifier {
  List<MediaFile> _mediaFiles = [];
  MediaApiService _apiService;
  AppSettings appSettings;

  MediaFileProvider({required this.appSettings})
      : _apiService = MediaApiService(appSettings: appSettings);

  // MediaFileProvider({required AppSettings appSettings})
  //     : _apiService = MediaApiService(appSettings: appSettings);

  List<MediaFile> get mediaFiles => _mediaFiles;

  void updateAppSettings(AppSettings _appSettings) {
    appSettings = _appSettings;
    _apiService = MediaApiService(
        appSettings:
            appSettings); // Create new instance of API Service with updated settings
    notifyListeners();
  }

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

  Future<bool> uploadMedia() async {
    try {
      bool success = await _apiService.uploadMedia();
      if (success) {
        fetchMediaFiles(); // refresh media files after successful upload
      } else {
        print('Failed to upload media file');
      }
      return success;
    } catch (e) {
      print('Error in uploading media: $e');
      return false;
    }
  }

  Future<bool> deleteMedia(String filename) async {
    try {
      bool success = await _apiService.deleteMedia(filename);
      if (success) {
        fetchMediaFiles(); // refresh media files after successful deletion
      } else {
        print('Failed to delete media file');
      }
      return success;
    } catch (e) {
      print('Error in deleting media: $e');
      return false;
    }
  }
}
