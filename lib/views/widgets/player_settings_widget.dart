import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';

class PlayerSettingsWidget extends StatefulWidget {
  @override
  _PlayerSettingsWidgetState createState() => _PlayerSettingsWidgetState();
}

class _PlayerSettingsWidgetState extends State<PlayerSettingsWidget> {
  late TextEditingController fpsController;

  @override
  void initState() {
    super.initState();
    fpsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    fpsController.text = playerProvider.player.fps.toString();
    playerProvider.addListener(updateFPS);
  }

  void updateFPS() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    fpsController.text = playerProvider.player.fps.toString();
  }

  @override
  void dispose() {
    Provider.of<PlayerProvider>(context, listen: false)
        .removeListener(updateFPS);
    fpsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Column(
      children: [
        Text(
          'Player Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: fpsController,
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
        const SizedBox(height: 20),
        const Text('Brightness'),
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
