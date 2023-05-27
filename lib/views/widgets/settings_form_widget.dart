import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophy_gui/view_models/app_settings_view_model.dart';
import 'package:trophy_gui/view_models/player_settings_view_model.dart';

class SettingsFormWidget extends StatefulWidget {
  @override
  _SettingsFormWidgetState createState() => _SettingsFormWidgetState();
}

class _SettingsFormWidgetState extends State<SettingsFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String serverIP = '';
  String serverPort = '';
  bool darkMode = false;
  double brightness = 0.0;
  double fps = 0.0;

  @override
  Widget build(BuildContext context) {
    final appSettingsViewModel = Provider.of<AppSettingsViewModel>(context);
    final playerSettingsViewModel =
        Provider.of<PlayerSettingsViewModel>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: appSettingsViewModel.serverIP,
            decoration: InputDecoration(labelText: 'Server IP'),
            onSaved: (value) {
              serverIP = value ?? '';
            },
            validator: (value) {
              final ipPattern = r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$';
              final ipRegex = RegExp(ipPattern);
              if (!ipRegex.hasMatch(value!)) {
                return 'Please enter a valid IP address';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: appSettingsViewModel.serverPort,
            decoration: InputDecoration(labelText: 'Server Port'),
            onSaved: (value) {
              serverPort = value ?? '';
            },
            validator: (value) {
              if (int.tryParse(value!) == null || int.parse(value) < 1 || int.parse(value) > 65535) {
                return 'Please enter a valid port number (1-65535)';
              }
              return null;
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: appSettingsViewModel.isDarkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
                appSettingsViewModel.setDarkMode(value);
              });
            },
          ),
         ListTile(
            title: Text('Brightness'),
            subtitle: Slider(
              value: playerSettingsViewModel.brightness,
              onChanged: (value) {
                setState(() {
                  brightness = value;
                  playerSettingsViewModel.setBrightness(value);
                });
              },
            ),
          ),
          ListTile(
            title: Text('FPS (Frames per Second)'),
            subtitle: Slider(
              value: playerSettingsViewModel.fps,
              onChanged: (value) {
                setState(() {
                  fps = value;
                  playerSettingsViewModel.setFPS(value);
                });
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                appSettingsViewModel.setServerIP(serverIP);
                appSettingsViewModel.setServerPort(serverPort);
              }
            },
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
