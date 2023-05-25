import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'themes.dart';
import 'control_page.dart';
import 'settings_page.dart';
import 'playlist_page.dart';
import 'video_service.dart';
import 'control_service.dart';
import 'player_providers.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerStateProvider()),
        ChangeNotifierProvider(create: (context) => PlayerModeProvider()),
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
              ControlService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: appTitle,
      theme: settingsProvider.settings.isDarkModeEnabled
          ? wwDarkTheme
          : wwLightTheme,
      home: MyHomePage(
        title: appTitle,
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

  final List<Widget> _widgetOptions = <Widget>[
    ControlPage(),
    PlaylistPage(),
    const SettingsPage(),
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
          items: bottomNavItems,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
          unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'constants.dart';
// import 'themes.dart';
// import 'control_page.dart';
// import 'settings_page.dart';
// import 'playlist_page.dart';
// import 'video_service.dart';
// import 'control_service.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => SettingsProvider(),
//         ),
//         ProxyProvider<SettingsProvider, VideoService>(
//           update: (context, settingsProvider, previousVideoService) =>
//               VideoService(
//             serverIP: settingsProvider.settings.serverIP,
//             serverPort: settingsProvider.settings.serverPort,
//           ),
//         ),
//         ProxyProvider<SettingsProvider, ControlService>(
//           update: (context, settingsProvider, previousControlService) =>
//               ControlService(
//             serverIP: settingsProvider.settings.serverIP,
//             serverPort: settingsProvider.settings.serverPort,
//           ),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final ThemeData wwDarkTheme = ThemeData.dark().copyWith(
//     colorScheme: ColorScheme.fromSeed(
//         seedColor: Colors.tealAccent, brightness: Brightness.dark),
//     useMaterial3: true,
//   );
//   final ThemeData wwLightTheme = ThemeData.light().copyWith(
//     colorScheme: ColorScheme.fromSeed(
//         seedColor: Colors.tealAccent, brightness: Brightness.light),
//     useMaterial3: true,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final settingsProvider = Provider.of<SettingsProvider>(context);
//
//     return MaterialApp(
//       title: 'Player App',
//       theme: settingsProvider.settings.isDarkModeEnabled
//           ? wwDarkTheme
//           : wwLightTheme,
//       home: MyHomePage(
//         title: 'Player App',
//         isDarkModeEnabled: settingsProvider.settings.isDarkModeEnabled,
//         onDarkModeToggle: (isDarkModeEnabled) {
//           settingsProvider.toggleDarkMode();
//         },
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   final String title;
//   final bool isDarkModeEnabled;
//   final Function(bool) onDarkModeToggle;
//
//   MyHomePage({
//     required this.title,
//     required this.isDarkModeEnabled,
//     required this.onDarkModeToggle,
//   });
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _widgetOptions = <Widget>[
//     ControlPage(),
//     PlaylistPage(),
//     const SettingsPage(),
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
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: _widgetOptions.elementAt(_selectedIndex),
//         bottomNavigationBar: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.control_camera),
//               label: 'Control',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.playlist_play),
//               label: 'Playlist',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
//           unselectedItemColor: Theme.of(context).colorScheme.onBackground,
//         ));
//   }
// }
