import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
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

  void updateAppSettings(AppSettings newSettings) {
    // Set the new AppSettings
    _appSettings = newSettings;

    // Create new instance of API Service with updated settings
    _apiService = MediaApiService(appSettings: newSettings);

    // Call method that uses the updated API service
    fetchMediaFiles();

    notifyListeners();
  }

  Future<void> fetchMediaFiles() async {
    try {
      List<MediaFile> mediaFiles = await _apiService.fetchMediaDirectory();
      _mediaFiles = mediaFiles;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch media files: $e');
    }
  }

  // Future<void> fetchMediaFiles() async {
  //   try {
  //     List<String> mediaNames = await _apiService.fetchMediaDirectory();
  //     _mediaFiles = mediaNames
  //         .map((name) => MediaFile(name: name, filepath: ''))
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Failed to fetch media files: $e');
  //   }
  // }

  Future<bool> uploadMedia(FilePickerResult? result) async {
    try {
      bool success = await _apiService.uploadMedia(result);
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

  Future<bool> deleteAllMedia() async {
    try {
      for (var mediaFile in _mediaFiles) {
        bool success = await _apiService.deleteMedia(mediaFile.name);
        if (!success) {
          print('Failed to delete media file: ${mediaFile.name}');
          return false;
        }
      }
      _mediaFiles = []; // clear the media files list
      notifyListeners();
      return true;
    } catch (e) {
      print('Error in deleting all media files: $e');
      return false;
    }
  }

  void deleteItem(int index) {
    deleteMedia(_mediaFiles[index].name);
  }

  Future<void> deleteAllItems() async {
    await deleteAllMedia();
  }

  Future<void> saveChanges() async {
    await fetchMediaFiles();
  }
}
