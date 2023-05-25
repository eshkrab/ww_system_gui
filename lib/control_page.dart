import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophy_gui/player_providers.dart';

import 'settings_page.dart';
import 'control_service.dart';
import 'constants.dart';
import 'themes.dart';

class CommandQueue {
  final List<Future<bool> Function()> _commands = [];

  void add(Future<bool> Function() command) {
    _commands.add(command);
    _processQueue();
  }

  Future<void> _processQueue() async {
    while (_commands.isNotEmpty) {
      bool success = await _commands.first.call();
      if (success) {
        _commands.removeAt(0);
      } else {
        // handle failure
        print("Error executing command");
        break;
      }
    }
  }
}

final CommandQueue commandQueue = CommandQueue();

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late ControlService controlService;
  late SettingsProvider settingsProvider;
  late PlayerStateProvider playerStateProvider;
  late PlayerModeProvider playerModeProvider;

  String _imageBytes = "";
  String _lastFrameBytes = "";

  // String _playerMode = playerModeRepeat;
  // String _playerState = playerStatePlaying;
  double _brightness = 0;

  late Timer _timer;
  int _frameInterval = 1000 ~/ frameRate; // 30 FPS
  late Stream<Uint8List> _videoStream;

  @override
  void initState() {
    super.initState();

    controlService = Provider.of<ControlService>(context, listen: false);
    // _videoStream = controlService.connectToWebSocket();

    // Initialize services here
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    playerStateProvider =
        Provider.of<PlayerStateProvider>(context, listen: false);
    playerModeProvider =
        Provider.of<PlayerModeProvider>(context, listen: false);

    controlService.getBrightness(settingsProvider).then((value) {
      setState(() {
        _brightness = value;
      });
    });
  }

  @override
  void dispose() {
    // controlService.disconnectFromWebSocket();
    super.dispose();
  }

  // void togglePlayPause() {
  //   setState(() {
  //     _playerState = _playerState == playerStatePlaying
  //         ? playerStatePaused
  //         : playerStatePlaying;
  //   });
  // }

  Widget _repeatModeButton() {
    IconData repeatIcon;
    Color color;
    String playerMode = playerModeProvider.playerMode;

    switch (playerMode) {
      case playerModeRepeat:
        repeatIcon = Icons.repeat;
        // color = Theme.of(context).colorScheme.onBackground;
        playerMode = playerModeRepeat;
        break;
      case playerModeRepeatOne:
        repeatIcon = Icons.repeat_one;
        // color = Theme.of(context).colorScheme.onBackground;
        playerMode = playerModeRepeatOne;
        break;
      default:
        repeatIcon = Icons.stop;
        // color = Theme.of(context).colorScheme.secondary;
        playerMode = playerModeStop;
    }

    return IconButton(
      onPressed: () async {
        // commandQueue.add(() async {
        bool success =
            await controlService.setMode(playerMode, settingsProvider);
        if (success) {
          playerModeProvider.setPlayerMode(playerMode);
        } else {
          print("Error setting mode:");
        }
        // return success;
        // });
      },
      icon: Icon(
        repeatIcon,
      ),
    );
  }

  Widget _playPauseButton() {
    return Builder(
      builder: (BuildContext context) {
        final String playerState = context.select<PlayerStateProvider, String>(
            (provider) => provider.playerState);
        Icon showIcon;
        String playerStateText;

        //if player is playing, show pause button
        //if player is paused, show play button
        if (playerState == playerStatePaused) {
          showIcon = Icon(Icons.play_arrow);
          playerStateText = "play";
        } else if (playerState == playerStatePlaying) {
          showIcon = Icon(Icons.pause_sharp);
          playerStateText = "pause";
        } else {
          showIcon = Icon(Icons.play_arrow);
          playerStateText = "play";
        }

        //print state of player
        print("PLAYPAUSE BUTTON Player state: $playerState");

        return IconButton(
            onPressed: () async {
              bool success = await controlService.setState(
                  playerStateText, settingsProvider);
              if (success) {
                print("Success setting state to $playerStateText ");
                controlService.getState(settingsProvider).then((value) =>
                    playerStateProvider.setPlayerState(playerStateText));
              } else {
                print("Error setting state to ");
              }
            },
            icon: showIcon);
      },
    );
  }

  // Widget _playPauseButton() {
  //   return Consumer<PlayerStateProvider>(
  //     builder: (context, playerStateProvider, child) {
  //       String playerState = playerStateProvider.playerState;
  //       Icon showIcon;
  //       String playerStateText;
  //       //if player is playing, show pause button
  //       //if player is paused, show play button
  //       if (playerState == playerStatePaused) {
  //         showIcon = Icon(Icons.play_arrow);
  //         playerStateText = "play";
  //       } else if (playerState == playerStatePlaying) {
  //         showIcon = Icon(Icons.pause_sharp);
  //         playerStateText = "pause";
  //       } else {
  //         showIcon = Icon(Icons.print);
  //         playerStateText = "play";
  //       }
  //
  //       //print state of player
  //       print("PLAYPAUSE BUTTON Player state: $playerState");
  //
  //       return IconButton(
  //           onPressed: () async {
  //             bool success = await controlService.setState(
  //                 playerStateText, settingsProvider);
  //             if (success) {
  //               controlService
  //                   .getState(settingsProvider)
  //                   .then((value) => playerStateProvider.setPlayerState(value));
  //             } else {
  //               print("Error setting state to ");
  //             }
  //           },
  //           icon: showIcon);
  //     },
  //   );
  // }
  //

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // For desktop and tablet
          return _buildWideContainers();
        } else {
          // For mobile
          return _buildNarrowContainers();
        }
      },
    );
  }

  Widget _buildWideContainers() {
    // For wider screens, we use a Row to place the video on the left and controls on the right.
    return Column(
      children: [
        // The controls will take up the remaining width.
        Flexible(
          flex: 1,
          child: _buildControls(),
        ),
        // // This Flexible widget and the AspectRatio widget inside it will make sure
        // // the video takes up a significant portion of the screen width, but keeps its aspect ratio.
        // Flexible(
        //   flex: 3,
        //   child: AspectRatio(
        //     aspectRatio: 16 /
        //         9, // Adjust this value according to your video's aspect ratio
        //     child: _buildVideo(),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildNarrowContainers() {
    // For narrower screens, we use a Column to place the video at the top and controls below.
    return Column(
      children: [
        // The controls will take up the remaining height.
        Expanded(
          child: _buildControls(),
        ),
        // // The video will take up as much width as possible and keep its aspect ratio.
        // AspectRatio(
        //   aspectRatio: 16 /
        //       9, // Adjust this value according to your video's aspect ratio
        //   child: _buildVideo(),
        // ),
      ],
    );
  }

  Widget _buildVideo() {
    return StreamBuilder<Uint8List>(
      stream: _videoStream,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        // if (snapshot.hasData) {
        //   return Image.memory(snapshot.data ?? Uint8List(0));
        // } else {
        return Center(
          child: Text('placeholder'),
        );
        // }
      },
    );
  }

  Widget _buildControls() {
    // The controls layout doesn't change depending on screen width,
    // so we can use the same widget in both _buildWideContainers and _buildNarrowContainers.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                controlService.setState('prev', settingsProvider);
              },
              icon: Icon(Icons.skip_previous),
            ),
            _playPauseButton(),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () async {
                bool success =
                    await controlService.setState('stop', settingsProvider);
                if (success) {
                  playerStateProvider.setPlayerState(playerStateStopped);
                }
              },
            ),
            IconButton(
              onPressed: () {
                controlService.setState('restart', settingsProvider);
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                controlService.setState('next', settingsProvider);
              },
              icon: Icon(Icons.skip_next),
            ),
            _repeatModeButton(),
          ],
        ),
        Slider(
          value: _brightness,
          min: 0.0,
          max: 1.0,
          divisions: 255,
          onChanged: (double value) {
            setState(() {
              _brightness = value;
            });
            controlService
                .setBrightness(_brightness, settingsProvider)
                .then((_) => controlService.getBrightness(settingsProvider))
                .then((value) => setState(() => _brightness = value));
          },
        ),
      ],
    );
  }
}
