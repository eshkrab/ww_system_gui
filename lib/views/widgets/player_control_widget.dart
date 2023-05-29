import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/player_view_model.dart';

class PlayerControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerViewModel =
        Provider.of<PlayerViewModel>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () => playerViewModel.previous(),
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () => playerViewModel.play(),
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () => playerViewModel.stop(),
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: () => playerViewModel.next(),
        ),
        IconButton(
          icon: _getPlayerModeIcon(playerViewModel.playerMode),
          onPressed: () => playerViewModel.togglePlayerMode(),
        ),
      ],
    );
  }

  Icon _getPlayerModeIcon(String playerMode) {
    switch (playerMode) {
      case 'repeat':
        return Icon(Icons.repeat, color: Colors.green);
      case 'repeat_one':
        return Icon(Icons.repeat_one, color: Colors.green);
      case 'halt':
      default:
        return Icon(Icons.repeat, color: Colors.grey);
    }
  }
}
