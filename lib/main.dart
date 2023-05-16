import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophy_gui/control_page.dart';
import 'package:trophy_gui/settings_page.dart';
import 'package:trophy_gui/playlist_page.dart';
import 'package:trophy_gui/video_service.dart';
import 'package:trophy_gui/control_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ProxyProvider<SettingsProvider, VideoService>(
          update: (context, settingsProvider, previousVideoService) =>
              VideoService(
            serverIP: settingsProvider.settings.serverIP,
            serverPort: settingsProvider.settings.serverPort,
          ),
        ),
        ProxyProvider<SettingsProvider, ControlService>(
          update: (context, settingsProvider, previousControlService) =>
              ControlService(
            serverIP: settingsProvider.settings.serverIP,
            serverPort: settingsProvider.settings.serverPort,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<VideoService>(
//           create: (_) =>
//               VideoService(serverIP: '192.168.86.22', serverPort: 5000),
//         ),
//         Provider<ControlService>(
//           create: (_) =>
//               ControlService(serverIP: '192.168.86.22', serverPort: 5000),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => SettingsProvider(),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final ThemeData wwTheme = ThemeData.dark().copyWith(
  //   primaryColor: Colors.blueGrey[900],
  //   accentColor: Colors.cyanAccent[700],
  // );
  final ThemeData wwDarkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal, brightness: Brightness.dark),
    useMaterial3: true,
  );
  final ThemeData wwLightTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal, brightness: Brightness.light),
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Video App',
      theme: settingsProvider.settings.isDarkModeEnabled
          ? wwDarkTheme
          : wwLightTheme,
      home: MyHomePage(
        title: 'Video App',
        isDarkModeEnabled: settingsProvider.settings.isDarkModeEnabled,
        onDarkModeToggle: (isDarkModeEnabled) {
          settingsProvider.toggleDarkMode();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final bool isDarkModeEnabled;
  final Function(bool) onDarkModeToggle;

  MyHomePage({
    required this.title,
    required this.isDarkModeEnabled,
    required this.onDarkModeToggle,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ControlPage(),
    PlaylistPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dark Mode Example',
//       theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Dark Mode Example'),
//         ),
//         body: Center(
//           child: Text(
//             'Hello, World!',
//             style: TextStyle(fontSize: 24.0),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _isDarkMode = !_isDarkMode;
//             });
//           },
//           child: Icon(Icons.brightness_6),
//         ),
//       ),
//     );
//   }
// }

//                                _
//   ___   __ _   _ __ ___   __ _(_)_ __
//  / _ \ / _` | | '_ ` _ \ / _` | | '_ \
// | (_) | (_| | | | | | | | (_| | | | | |
//  \___/ \__, | |_| |_| |_|\__,_|_|_| |_|
//        |___/
//

// import 'package:flutter/material.dart';
// import 'package:trophy_gui/control_page.dart';
// import 'package:trophy_gui/playlist_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video App',
//       theme: ThemeData(
//         primarySwatch: .green,
//       ),
//       home: MyHomePage(title: 'Video App'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _widgetOptions = <Widget>[
//     ControlPage(),
//     PlaylistPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.control_camera),
//             label: 'Control',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.playlist_play),
//             label: 'Playlist',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
