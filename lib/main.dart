// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';
import 'views/pages/player_page.dart';
import 'views/pages/settings_page.dart';
import 'views/pages/media_page.dart';
import 'services/api_service.dart';
import 'models/app_settings.dart';
import 'view_models/settings_view_model.dart';
import 'view_models/player_view_model.dart';
import 'view_models/media_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppSettings appSettings = AppSettings(
        isDarkModeEnabled: true, serverIP: '192.168.86.144', serverPort: 8080);

    final mediaApiService = MediaApiService(appSettings: appSettings);
    final playlistApiService = PlaylistApiService(appSettings: appSettings);
    final playerApiService = PlayerApiService(appSettings: appSettings);
    final settingsApiService = SettingsApiService(appSettings: appSettings);

    // Pass the AppSettingsViewModel and API services to your PlayerViewModel
    final playerViewModel = PlayerViewModel(
      playerApiService: playerApiService,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(
            create: (_) => PlayerViewModel(
                playerApiService:
                    PlayerApiService(SettingsViewModel.appSettings))),
        ChangeNotifierProvider(
            create: (_) => MediaViewModel(mediaApiService: MediaApiService())),
        ProxyProvider<SettingsViewModel, ApiService>(
          update: (_, settingsViewModel, __) =>
              ApiService(settingsProvider: settingsViewModel),
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        theme: wwLightTheme,
        darkTheme: wwDarkTheme,
        themeMode:
            context.watch<SettingsViewModel>().appSettings.isDarkModeEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
        home: MyHomePage(title: appTitle),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _MyHomePageState(),
      child: Consumer<_MyHomePageState>(
        builder: (context, state, _) {
          final settingsViewModel = Provider.of<SettingsViewModel>(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                Switch(
                  value: settingsViewModel.appSettings.isDarkModeEnabled,
                  onChanged: (value) {
                    settingsViewModel.toggleDarkMode();
                  },
                ),
              ],
            ),
            body: state._widgetOptions.elementAt(state._selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              items: bottomNavItems,
              currentIndex: state._selectedIndex,
              onTap: state._onItemTapped,
              selectedItemColor:
                  Theme.of(context).colorScheme.onPrimaryContainer,
              unselectedItemColor: Theme.of(context).colorScheme.onBackground,
            ),
          );
        },
      ),
    );
  }
}

class _MyHomePageState with ChangeNotifier {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PlayerPage(),
    MediaPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'utils/constants.dart';
// import 'utils/themes.dart';
// import 'views/pages/player_page.dart';
// import 'views/pages/settings_page.dart';
// import 'views/pages/media_page.dart';
// import 'services/api_service.dart';
// import 'models/app_settings.dart';
// import 'view_models/settings_view_model.dart';
// import 'view_models/player_view_model.dart';
// import 'view_models/media_view_model.dart';
//
// // main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'utils/constants.dart';
// import 'utils/themes.dart';
// import 'views/pages/player_page.dart';
// import 'views/pages/settings_page.dart';
// import 'views/pages/media_page.dart';
// import 'services/api_service.dart';
// import 'models/app_settings.dart';
// import 'view_models/settings_view_model.dart';
// import 'view_models/player_view_model.dart';
// import 'view_models/media_view_model.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => SettingsViewModel()),
//         ChangeNotifierProvider(
//             create: (_) =>
//                 PlayerViewModel(playerApiService: PlayerApiService())),
//         ChangeNotifierProvider(
//             create: (_) =>
//                 MediaViewModel(mediaApiService: MediaApiService())),
//         ProxyProvider<SettingsViewModel, ApiService>(
//           update: (_, settingsViewModel, __) =>
//               ApiService(settingsProvider: settingsViewModel),
//         ),
//       ],
//       child: MaterialApp(
//         title: appTitle,
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: context.watch<SettingsViewModel>().appSettings.isDarkModeEnabled
//             ? ThemeMode.dark
//             : ThemeMode.light,
//         home: MyHomePage(title: appTitle),
//       ),
//     );
//   }
// }
//
// void main() {
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SettingsViewModel()),
//         ChangeNotifierProvider(
//             create: (context) =>
//                 PlayerViewModel(playerApiService: PlayerApiService())),
//         ChangeNotifierProvider(
//             create: (context) =>
//                 MediaViewModel(mediaApiService: MediaApiService())),
//         ProxyProvider<SettingsViewModel, ApiService>(
//           update: (context, settingsViewModel, previousApiService) =>
//               ApiService(
//             settingsProvider: settingsViewModel,
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
//   @override
//   Widget build(BuildContext context) {
//     final settingsViewModel = Provider.of<SettingsViewModel>(context);
//
//     return MaterialApp(
//       title: appTitle,
//       theme: settingsViewModel.appSettings.isDarkModeEnabled
//           ? wwDarkTheme
//           : wwLightTheme,
//       home: MyHomePage(
//         title: appTitle,
//         isDarkModeEnabled: settingsViewModel.appSettings.isDarkModeEnabled,
//         onDarkModeToggle: (isDarkModeEnabled) {
//           settingsViewModel.toggleDarkMode();
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
//     PlayerPage(),
//     MediaPage(),
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
//           items: bottomNavItems,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
//           unselectedItemColor: Theme.of(context).colorScheme.onBackground,
//         ));
//   }
// }
