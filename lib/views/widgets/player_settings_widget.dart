import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';

class PlayerSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Column(
      children: [
        Text(
          'Player Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'FPS',
            hintText: 'Enter a number between 1-150',
          ),
          keyboardType: TextInputType.number,
          initialValue: playerProvider.player.fps.toString(),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                int.parse(value) <= 0 ||
                int.parse(value) > 150) {
              return 'Please enter a valid FPS (1-150)';
            }
            return null;
          },
          onChanged: (value) =>
              playerProvider.setPlayerFPS(double.parse(value)),
        ),
        Slider(
          min: 0.0,
          max: 1.0,
          divisions: 255,
          value: playerProvider.player.brightness.toDouble(),
          label: 'Brightness',
          onChanged: (value) => playerProvider.setPlayerBrightness(value),
        ),
      ],
    );
  }
}
