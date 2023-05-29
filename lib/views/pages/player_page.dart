import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophy_gui/view_models/player_view_model.dart';
import 'package:trophy_gui/views/widgets/player_control_widget.dart';

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (context) => PlayerViewModel(),
    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: Consumer<PlayerViewModel>(
        builder: (context, model, child) => Column(
          children: <Widget>[
            PlayerControlWidget(),
            // Add here the widget for the WebSocket stream.
          ],
        ),
      ),
      // ),
    );
  }
}
