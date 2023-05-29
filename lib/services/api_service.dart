import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../models/app_settings.dart';

class ApiService {
  final AppSettings _appSettings;

  ApiService(this._appSettings);

  String getBaseUrl() {
    return 'http://${_appSettings.serverIP}:${_appSettings.serverPort}/api';
  }
}

class MediaApiService extends ApiService {
  MediaApiService({required AppSettings appSettings})
      : super(appSettings: appSettings);

  // Methods for uploading and deleting media files
  Future<List<String>> fetchMediaDirectory() async {
    final response = await http.get(Uri.parse('${getBaseUrl()}/state'));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body)['videos']);
    } else {
      throw Exception('Failed to load media directory');
    }
  }

  Future<bool> uploadMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mov'],
    );

    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      String fileName = result.files.single.name;

      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );

      FormData formData = FormData.fromMap({'file': multipartFile});

      // Create a Dio instance
      Dio dio = Dio();

      try {
        var response = await dio.post(
          '${getBaseUrl()}/videos/upload',
          data: formData,
        );
        if (response.statusCode == 200 && response.data['success'] == true) {
          print('Media uploaded successfully');
          // Refetch the media directory after uploading the media
          return true;
        } else {
          print('Failed to upload media');
          return false;
        }
      } catch (e) {
        print('Error while uploading media: $e');
        return false;
      }
    } else {
      print('No file selected');
      return false;
    }
  }

  Future<void> deleteMedia(String filename) async {
    final response = await http.post(
      Uri.parse('${getBaseUrl()}/videos/delete'),
      body: {'filename': filename},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete media');
    }
  }
}

class PlaylistApiService extends ApiService {
  PlaylistApiService({required AppSettings appSettings})
      : super(appSettings: appSettings);

  // Methods for getting and changing the playlist
  Future<List<String>> fetchPlaylist() async {
    final response = await http.get(Uri.parse('${getBaseUrl()}/playlist'));

    if (response.statusCode == 200) {
      final playlistData = jsonDecode(response.body);
      return List<String>.from(playlistData['playlist']);
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<void> savePlaylist(List<String> playlist, String mode) async {
    final response = await http.post(
      Uri.parse('${getBaseUrl()}/playlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'playlist': playlist, 'mode': mode}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save playlist');
    }
  }
}

class PlayerApiService extends ApiService {
  PlayerApiService({required AppSettings appSettings})
      : super(appSettings: appSettings);

  // Methods for controlling the player
  Future<String> getState() async {
    String stateUrl = '${getBaseUrl()}/state';
    final response = await http.get(Uri.parse(stateUrl));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['state']);
      return jsonDecode(response.body)['state'];
    } else {
      throw Exception('Failed to fetch state');
    }
  }

  Future<bool> setState(String value) async {
    String stateUrl = '${getBaseUrl()}/state';
    final response = await http.post(
      Uri.parse(stateUrl),
      body: {'state': value},
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      return false;
      // throw Exception('Failed to set state');
    }
    return true;
  }

  Future<String> getMode() async {
    String stateUrl = '${getBaseUrl()}/mode';
    final response = await http.get(Uri.parse(stateUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['mode'];
    } else {
      throw Exception('Failed to fetch mode');
    }
  }

  Future<bool> setMode(String value) async {
    String stateUrl = '${getBaseUrl()}/mode';
    final response = await http.post(
      Uri.parse(stateUrl),
      body: {'mode': value},
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      return false;
      // throw Exception('Failed to send mode');
    }
    return true;
  }
}

class SettingsApiService extends ApiService {
  SettingsApiService({required AppSettings appSettings})
      : super(appSettings: appSettings);

  // Methods for getting and setting brightness or other settings
  Future<double> getBrightness() async {
    String brightnessUrl = '${getBaseUrl()}/brightness';
    final response = await http.get(Uri.parse(brightnessUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['brightness'].toDouble();
    } else {
      throw Exception('Failed to fetch brightness');
    }
  }

  Future<bool> setBrightness(double brightness) async {
    String brightnessUrl = '${getBaseUrl()}/brightness';
    final response = await http.post(
      Uri.parse(brightnessUrl),
      body: {
        'brightness': (brightness * 100.0).toStringAsFixed(2)
      }, // brightness in range 0.0 to 1.0
    );

    if (response.statusCode != 200) {
      return false;
      // throw Exception('Failed to update brightness');
    }
    return true;
  }

  //api calls for setting and getting FPS
  Future<double> getFPS() async {
    String fpsUrl = '${getBaseUrl()}/fps';
    final response = await http.get(Uri.parse(fpsUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['fps'].toDouble();
    } else {
      throw Exception('Failed to fetch fps');
    }
  }

  Future<bool> setFPS(double fps) async {
    String fpsUrl = '${getBaseUrl()}/fps';
    final response = await http.post(
      Uri.parse(fpsUrl),
      body: {'fps': (fps).toStringAsFixed(2)}, // fps in range 0.0 to 1.0
    );

    if (response.statusCode != 200) {
      return false;
      // throw Exception('Failed to update fps');
    }
    return true;
  }
}
