import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool _isValidIP(String? address) {
    final ipRegExp = RegExp(
        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    final hostnameRegExp = RegExp(
        r'^([0-9a-zA-Z](?:[0-9a-zA-Z\-]{0,61}[0-9a-zA-Z])?\.)+[a-zA-Z]{2,}$');

    return ipRegExp.hasMatch(address ?? '') ||
        hostnameRegExp.hasMatch(address ?? '');
  }

  bool _isValidPort(int? port) {
    return port != null && port >= 0 && port < 65536; // Allowing 0 as port
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, appSettingsProvider, _) {
        var appSettings = appSettingsProvider.appSettings;
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'App Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: appSettings.serverIP,
                decoration: const InputDecoration(labelText: 'Server IP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the server IP';
                  }
                  if (!_isValidIP(value)) {
                    return 'Please enter a valid IP address or hostname';
                  }
                  return null;
                },
                onChanged: (value) {
                  //UPDATE SETTINGS
                  appSettingsProvider.updateServerSettings(serverIP: value);
                },
              ),
              TextFormField(
                initialValue: appSettings.serverPort.toString(),
                decoration: const InputDecoration(labelText: 'Server Port'),
                validator: (value) {
                  int? port = int.tryParse(value ?? '');
                  if (value == null || value.isEmpty) {
                    return 'Please enter the server port';
                  }
                  if (!_isValidPort(port)) {
                    return 'Please enter a valid port number (0-65535)';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    //UPDATE SETTINGS
                    appSettingsProvider.updateServerSettings(
                        serverPort: int.parse(value));
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: appSettings.isDarkModeEnabled,
                onChanged: (bool value) {
                  appSettingsProvider.toggleDarkMode();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All fields are valid.
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
