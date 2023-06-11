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
    AppSettings appSettings = AppSettings(
        // isDarkModeEnabled: true, serverIP: '192.168.86.103', serverPort: 8000);
        isDarkModeEnabled: true,
        serverIP: '10.0.0.5',
        serverPort: 8000);

    final playerProvider = PlayerProvider(
        appSettings: appSettings,
        player: Player(state: '', brightness: 1.0, fps: 1.0));

    final mediaFileProvider = MediaFileProvider(appSettings: appSettings);

    final playlistProvider = PlaylistProvider(
        appSettings: appSettings,
        playlist: Playlist(playlist: [], mode: 'repeat'));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AppSettingsProvider(appSettings: appSettings)),
        ChangeNotifierProvider(create: (_) => playerProvider),
        ChangeNotifierProvider(create: (_) => mediaFileProvider),
        ChangeNotifierProvider(create: (_) => playlistProvider),
        ChangeNotifierProvider(
            create: (_) => NavigationProvider()), // <--- Add this
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
            home: MyHomePage(title: appTitle),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppSettingsProvider, NavigationProvider>(
      builder: (context, appSettingsProvider, navProvider, _) {
        return Scaffold(
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
