import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String _defaultIp = 'localhost';
int _defaultPort = 8000;

class Settings {
  final String serverIP;
  final int serverPort;
  final bool isDarkModeEnabled;

  Settings({
    required this.serverIP,
    required this.serverPort,
    required this.isDarkModeEnabled,
  });

  Settings copyWith({
    String? serverIP,
    int? serverPort,
    bool? isDarkModeEnabled,
  }) {
    return Settings(
      serverIP: serverIP ?? this.serverIP,
      serverPort: serverPort ?? this.serverPort,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
    );
  }
}

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings(
    serverIP: _defaultIp,
    serverPort: _defaultPort,
    isDarkModeEnabled: true,
  );

  Settings get settings => _settings;

  void updateServerIP(String serverIP) {
    _settings = _settings.copyWith(serverIP: serverIP);
    notifyListeners();
  }

  void updateServerPort(int serverPort) {
    _settings = _settings.copyWith(serverPort: serverPort);
    notifyListeners();
  }

  void toggleDarkMode() {
    _settings =
        _settings.copyWith(isDarkModeEnabled: !_settings.isDarkModeEnabled);
    notifyListeners();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Server IP Address'),
            TextField(
              onChanged: (value) => settingsProvider.updateServerIP(value),
              decoration: InputDecoration(
                hintText: 'Enter server IP address',
              ),
              controller: TextEditingController(
                  text: settingsProvider.settings.serverIP),
            ),
            SizedBox(height: 16.0),
            Text('Server Port'),
            TextField(
              onChanged: (value) =>
                  settingsProvider.updateServerPort(int.tryParse(value) ?? 0),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter server port',
              ),
              controller: TextEditingController(
                  text: settingsProvider.settings.serverPort.toString()),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('App Dark Mode'),
                  Switch(
                    value: settingsProvider.settings.isDarkModeEnabled,
                    onChanged: (value) => settingsProvider.toggleDarkMode(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   String _serverIp = '192.168.86.22';
//   String _serverPort = '5000';
//   bool _isDarkMode = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Server Settings',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Server IP'),
//               initialValue: _serverIp,
//               onChanged: (value) {
//                 setState(() {
//                   _serverIp = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Server Port'),
//               initialValue: _serverPort,
//               onChanged: (value) {
//                 setState(() {
//                   _serverPort = value;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             Text(
//               'App Appearance',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             SwitchListTile(
//               title: Text('Dark Mode'),
//               value: _isDarkMode,
//               onChanged: (value) {
//                 setState(() {
//                   _isDarkMode = value;
//                 });
//                 // Change the theme based on the user's preference
//                 if (_isDarkMode) {
//                   SystemChrome.setSystemUIOverlayStyle(
//                     SystemUiOverlayStyle.dark.copyWith(
//                       statusBarBrightness: Brightness.dark,
//                     ),
//                   );
//                 } else {
//                   SystemChrome.setSystemUIOverlayStyle(
//                     SystemUiOverlayStyle.light.copyWith(
//                       statusBarBrightness: Brightness.light,
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
