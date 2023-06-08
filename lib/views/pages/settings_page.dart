import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/settings_form_widget.dart';
import '../widgets/player_settings_widget.dart';
import '../../providers/settings_provider.dart';
import '../../providers/player_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<void> _fetchPlayer;

  @override
  void initState() {
    super.initState();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    _fetchPlayer = Future.wait([
      playerProvider.fetchPlayerBrightness(),
      playerProvider.fetchPlayerFPS(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _fetchPlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('An error occurred!'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: SettingsWidget(),
                    flex: 1,
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Expanded(
                    child: Consumer<PlayerProvider>(
                      builder: (context, playerProvider, child) =>
                          PlayerSettingsWidget(),
                    ),
                    flex: 1,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/settings_form_widget.dart';
// import '../widgets/player_settings_widget.dart';
// import '../../providers/settings_provider.dart';
// import '../../providers/player_provider.dart';
//
// class SettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final playerProvider = Provider.of<PlayerProvider>(context);
//     playerProvider.fetchPlayerBrightness();
//     playerProvider.fetchPlayerFPS();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SettingsWidget(),
//               flex: 1,
//             ),
//             Divider(
//               color: Colors.black38,
//             ),
//             Expanded(
//               child: PlayerSettingsWidget(),
//               flex: 1,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
