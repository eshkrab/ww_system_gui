import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/settings_form_widget.dart';
import '../widgets/player_settings_widget.dart';
import '../../providers/settings_provider.dart';
import '../../providers/player_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SettingsWidget(),
              flex: 1,
            ),
            Divider(
              color: Colors.black38,
            ),
            Expanded(
              child: PlayerSettingsWidget(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
