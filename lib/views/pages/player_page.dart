import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/player_control_widget.dart';
import '../../providers/player_provider.dart';

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          playerProvider.fetchPlayerState(),
          playerProvider.fetchPlayerBrightness(),
          playerProvider.fetchPlayerFPS(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Consumer<PlayerProvider>(
              builder: (context, model, child) => Column(
                children: <Widget>[
                  PlayerControlWidget(),
                  // Add here the widget for the WebSocket stream.
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/player_control_widget.dart';
// import '../../providers/player_provider.dart';
//
// class PlayerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final playerProvider = Provider.of<PlayerProvider>(context);
//     playerProvider.fetchPlayerState();
//     playerProvider.fetchPlayerBrightness();
//     playerProvider.fetchPlayerFPS();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Player'),
//       ),
//       body: Consumer<PlayerProvider>(
//         builder: (context, model, child) => Column(
//           children: <Widget>[
//             PlayerControlWidget(),
//             // Add here the widget for the WebSocket stream.
//           ],
//         ),
//       ),
//     );
//   }
// }
