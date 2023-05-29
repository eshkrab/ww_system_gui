import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/settings_view_model.dart';
import '../../view_models/player_view_model.dart';
import '../../views/widgets/settings_form_widget.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (context) => SettingsViewModel(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => PlayerViewModel(
    //           playerApiService:
    //               PlayerApiService()), // Replace this with actual PlayerApiService instance
    //     ),
    //   ],
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SettingsFormWidget(),
      ),
      // ),
    );
  }
}
