import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/player_control_widget.dart';
import '../../providers/player_provider.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Future<void> _fetchPlayer;

  @override
  void initState() {
    super.initState();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    _fetchPlayer = Future.wait([
      playerProvider.fetchPlayerState(),
      playerProvider.fetchPlayerBrightness(),
      playerProvider.fetchPlayerFPS(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: FutureBuilder(
        future: _fetchPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
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
