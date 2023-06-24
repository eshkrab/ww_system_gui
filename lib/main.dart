import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';
import 'views/pages/player_page.dart';
import 'views/pages/settings_page.dart';
import 'views/pages/media_page.dart';
import 'models/app_settings.dart';
import 'models/player.dart';
import 'models/playlist.dart';
import 'models/media.dart';
import 'providers/settings_provider.dart';
import 'providers/player_provider.dart';
import 'providers/media_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/navigation_provider.dart'; // <--- Add this

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettings(
      isDarkModeEnabled: true,
      serverIP: 'ww-system-claude.local',
      serverPort: 8000,
    );

    final mediaFileProvider = MediaFileProvider(appSettings: appSettings);

    final playerProvider = PlayerProvider(
      appSettings: appSettings,
      player: Player(state: '', brightness: 1.0, fps: 1.0),
    );

    final playlistProvider = PlaylistProvider(
      appSettings: appSettings,
      playlist: Playlist(playlist: [], mode: 'repeat'),
    );

    final settingsProvider = AppSettingsProvider(
      appSettings: appSettings,
      mediaProvider: mediaFileProvider,
      playerProvider: playerProvider,
      playlistProvider: playlistProvider,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mediaFileProvider),
        ChangeNotifierProvider.value(value: playerProvider),
        ChangeNotifierProvider.value(value: playlistProvider),
        ChangeNotifierProvider.value(value: NavigationProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, appSettingsProvider, child) {
          return MaterialApp(
            title: appTitle,
            theme: wwLightTheme,
            darkTheme: wwDarkTheme,
            themeMode: appSettingsProvider.appSettings.isDarkModeEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
            home:
                MyHomePage(title: appTitle, settingsProvider: settingsProvider),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final AppSettingsProvider settingsProvider; // add this

  MyHomePage({required this.title, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppSettingsProvider, NavigationProvider, PlayerProvider>(
      builder: (context, appSettingsProvider, navProvider, playerProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: DropdownButton(
              value: appSettingsProvider.appSettings.serverIP,
              onChanged: (value) {
                String serverIpWithLocal = '${value.toString()}.local';
                appSettingsProvider.updateServerSettings(
                  serverIP: serverIpWithLocal,
                );
              },
              items: appSettingsProvider.appSettings.serverNodes
                  .map<DropdownMenuItem<String>>((node) {
                return DropdownMenuItem(
                  value: node.ip ?? node.hostname!,
                  child: Text(node.ip ?? ('${node.hostname}.local')),
                );
              }).toList(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => settingsProvider.fetchNodes(),
              ),
            ],
          ),
          body: IndexedStack(
            index: navProvider.selectedIndex,
            children: [
              PlayerPage(),
              MediaPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: navProvider.selectedIndex,
            onTap: navProvider.onItemTapped,
            selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
            unselectedItemColor: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   final String title;
//
//   MyHomePage({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer3<AppSettingsProvider, NavigationProvider, PlayerProvider>(
//       builder: (context, appSettingsProvider, navProvider, playerProvider, _) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//                 "${appSettingsProvider.appSettings.serverIP}:${appSettingsProvider.appSettings.serverPort}"),
//           ),
//           body: IndexedStack(
//             index: navProvider.selectedIndex,
//             children: [
//               PlayerPage(),
//               MediaPage(),
//               SettingsPage(),
//             ],
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             items: bottomNavItems,
//             currentIndex: navProvider.selectedIndex,
//             onTap: navProvider.onItemTapped,
//             selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
//             unselectedItemColor: Theme.of(context).colorScheme.onBackground,
//           ),
//         );
//       },
//     );
//   }
// }
