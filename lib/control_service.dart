import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ControlService {
  final String serverIP;
  final int serverPort;

  ControlService({required this.serverIP, required this.serverPort});

  Future<void> sendRequest(String url, String key, String value) async {
    final response = await http.post(
      Uri.parse(url),
      body: {key: value},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send request');
    }
  }

  Future<double> fetchBrightness() async {
    final response = await http
        .get(Uri.parse('http://$serverIP:$serverPort/api/brightness'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['brightness']).toDouble() / 100.0;
    } else {
      throw Exception('Failed to fetch brightness');
    }
  }

  Future<void> updateBrightness(double brightness) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:$serverPort/api/brightness'),
      body: {'brightness': (brightness * 100.0).toStringAsFixed(0)},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update brightness');
    }
  }
}
