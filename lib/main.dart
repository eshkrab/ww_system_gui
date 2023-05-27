import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './utils/constants.dart';
import './utils/themes.dart';
import './views/pages/player_page.dart';
import './views/pages/settings_page.dart';
import './views/pages/media_page.dart';
import './services/api_service.dart';
import './models/app_settings.dart';
import './view_models/settings_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsViewModel()),
        ProxyProvider<SettingsViewModel, ApiService>(
          update: (context, settingsViewModel, previousApiService) =>
              ApiService(
            settingsProvider: settingsViewModel,
          ),
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
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    return MaterialApp(
      title: appTitle,
      theme: settingsViewModel.appSettings.isDarkModeEnabled
          ? wwDarkTheme
          : wwLightTheme,
      home: MyHomePage(
        title: appTitle,
        isDarkModeEnabled: settingsViewModel.appSettings.isDarkModeEnabled,
        onDarkModeToggle: (isDarkModeEnabled) {
          settingsViewModel.toggleDarkMode();
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
    PlayerPage(),
    MediaPage(),
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
