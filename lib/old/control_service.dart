import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trophy_gui/settings_page.dart';

class ControlService {
  Future<void> sendRequest(String url, String key, String value) async {
    final response = await http.post(
      Uri.parse(url),
      body: {key: value},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send request');
    }
  }

  Future<String> getState(SettingsProvider settingsProvider) async {
    String stateUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/state';
    final response = await http.get(Uri.parse(stateUrl));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['state']);
      return jsonDecode(response.body)['state'];
    } else {
      throw Exception('Failed to fetch state');
    }
  }

  Future<bool> setState(String value, SettingsProvider settingsProvider) async {
    String stateUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/state';
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

  Future<String> getMode(SettingsProvider settingsProvider) async {
    String stateUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/mode';
    final response = await http.get(Uri.parse(stateUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['mode'];
    } else {
      throw Exception('Failed to fetch mode');
    }
  }

  Future<bool> setMode(String value, SettingsProvider settingsProvider) async {
    String stateUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/mode';
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

  Future<double> getBrightness(SettingsProvider settingsProvider) async {
    String brightnessUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/brightness';
    final response = await http.get(Uri.parse(brightnessUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['brightness'].toDouble();
    } else {
      throw Exception('Failed to fetch brightness');
    }
  }

  Future<bool> setBrightness(
      double brightness, SettingsProvider settingsProvider) async {
    String brightnessUrl =
        'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/brightness';
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
}
