import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';
import '../../providers/playlist_provider.dart';

class PlayerControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () => playerProvider.previous(),
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () => playerProvider.play(),
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () => playerProvider.stop(),
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: () => playerProvider.next(),
        ),
        IconButton(
          icon: _getPlayerModeIcon(context, playlistProvider.playlist.mode),
          onPressed: () => playlistProvider.toggleMode(),
        ),
      ],
    );
  }

  Icon _getPlayerModeIcon(BuildContext context, String playerMode) {
    switch (playerMode) {
      case 'repeat':
        //return repeat icon in theme's accent color
        return Icon(Icons.repeat, color: Colors.green);
      // return Icon(Icons.repeat, color: Theme.of(context).accentColor);
      case 'repeat_one':
        return Icon(Icons.repeat_one, color: Colors.green);
      // return Icon(Icons.repeat_one, color: Theme.of(context).accentColor);
      // case 'repeat_none':
      default:
        return Icon(Icons.stop, color: Colors.grey);
      // return Icon(Icons.repeat, color: Theme.of(context).accentColor);
    }
  }
}
