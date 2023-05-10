import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final String serverIP;
  final int serverPort;

  VideoService({required this.serverIP, required this.serverPort});

  Future<List<String>> fetchVideoDirectory() async {
    final response =
        await http.get(Uri.parse('http://$serverIP:$serverPort/api/videos'));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body)['videos']);
    } else {
      throw Exception('Failed to load video directory');
    }
  }

  Future<bool> uploadVideo() async {
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
          'http://$serverIP:$serverPort/api/videos/upload',
          data: formData,
        );
        if (response.statusCode == 200 && response.data['success'] == true) {
          print('Video uploaded successfully');
          // Refetch the video directory after uploading the video
          return true;
        } else {
          print('Failed to upload video');
          return false;
        }
      } catch (e) {
        print('Error while uploading video: $e');
        return false;
      }
    } else {
      print('No file selected');
      return false;
    }
  }

  // Future<void> uploadVideo() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['mp4', 'avi', 'mov']);
  //
  //   if (result != null) {
  //     Uint8List fileBytes = result.files.single.bytes!;
  //     String fileName = result.files.single.name;
  //
  //     MultipartFile multipartFile = MultipartFile.fromBytes(
  //       fileBytes,
  //       filename: fileName,
  //     );
  //
  //     FormData formData = FormData.fromMap({'file': multipartFile});
  //
  //     // Create a Dio instance
  //     Dio dio = Dio();
  //
  //     try {
  //       var response = await dio.post(
  //           'http://$serverIP:$serverPort/api/videos/upload',
  //           data: formData);
  //       if (response.statusCode == 200 && response.data['success'] == true) {
  //         print('Video uploaded successfully');
  //         // Refetch the video directory after uploading the video
  //         return;
  //       } else {
  //         print('Failed to upload video');
  //       }
  //     } catch (e) {
  //       print('Error while uploading video: $e');
  //     }
  //   } else {
  //     print('No file selected');
  //   }
  // }

  Future<void> deleteVideo(String filename) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:$serverPort/api/videos/delete'),
      body: {'filename': filename},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete video');
    }
  }

  // Future<Map<String, dynamic>> fetchPlaylist() async {
  //   // Replace 'localhost' with your server's IP address or domain name
  //   final response =
  //       await http.get(Uri.parse('http://$serverIP:$serverPort/api/playlist'));
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load playlist');
  //   }
  // }

  Future<List<String>> fetchPlaylist() async {
    final response =
        await http.get(Uri.parse('http://$serverIP:$serverPort/api/playlist'));

    if (response.statusCode == 200) {
      final playlistData = jsonDecode(response.body);
      return List<String>.from(playlistData['playlist']);
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  // Future<List<String>> fetchPlaylist() async {
  //   // Replace 'localhost' with your server's IP address or domain name
  //   final response =
  //       await http.get(Uri.parse('http://$serverIP:$serverPort/api/playlist'));
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     final List<dynamic> playlistData = jsonData['data'];
  //     final List<String> playlist =
  //         playlistData.map((data) => data['name'] as String).toList();
  //     return playlist;
  //   } else {
  //     throw Exception('Failed to load playlist');
  //   }
  // }

  Future<void> savePlaylist(List<String> playlist, String mode) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:$serverPort/api/playlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'playlist': playlist, 'mode': mode}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save playlist');
    }
  }
}
