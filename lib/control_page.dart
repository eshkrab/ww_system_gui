import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophy_gui/settings_page.dart';
import 'package:trophy_gui/control_service.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/html.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // VideoService video_service = context.read<VideoService>();
  late ControlService controlService;
  late SettingsProvider settingsProvider;

  String _imageBytes = "";
  String _lastFrameBytes = "";

  String get brightnessUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/brightness';
  String get stateUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/state';

  String _playbackMode = 'loop'; // Default playback mode
  double _brightness = 0; // Default brightness (Range: 0.0 - 1.0)
  String _playbackState = 'playing';

  late Timer _timer;
  int _frameInterval = 1000 ~/ 15; // 30 FPS
  late Stream<Uint8List> _videoStream;

  @override
  void initState() {
    super.initState();

    final channel =
        HtmlWebSocketChannel.connect('ws://192.168.86.22:5000/websocket');
    _videoStream = channel.stream.map((frameData) {
      // Decode the frame data to a Uint8List
      return base64Decode(frameData);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize services here
    controlService = Provider.of<ControlService>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    controlService.fetchBrightness().then((value) {
      setState(() {
        _brightness = value;
      });
    });
  }

  @override
  void dispose() {
    // socket!.disconnect();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      _playbackState = _playbackState == 'playing' ? 'paused' : 'playing';
    });
  }

  Widget _repeatModeButton() {
    switch (_playbackMode) {
      case 'repeat':
        return IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.repeat,
              color: Theme.of(context).colorScheme.onBackground,
            ));
      case 'repeat_one':
        return IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.repeat_one,
              color: Theme.of(context).colorScheme.onBackground,
            ));
      default:
        return IconButton(
            onPressed: () {},
            icon: Icon(Icons.repeat),
            color: Colors.grey[700]);
    }
  }

  Widget _playPauseButton() {
    IconButton play = IconButton(
      onPressed: () {
        //add action
        togglePlayPause();
        controlService.sendRequest(stateUrl, "state", "play");
      },
      icon: Icon(Icons.play_arrow),
    );

    IconButton pause = IconButton(
      onPressed: () {
        //add action
        togglePlayPause();
        controlService.sendRequest(stateUrl, "state", "pause");
      },
      icon: Icon(Icons.pause_sharp),
    );

    IconButton button = _playbackState == 'playing' ? play : pause;
    return button;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Image/Video area
        Expanded(
          child: Container(
            height: 300,
            width: double.infinity,
            // Add your image or video widget here.
            child: StreamBuilder<Uint8List>(
              stream: _videoStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data ?? Uint8List(0));
                } else {
                  // return CircularProgressIndicator(); // Or some other placeholder
                  return Center(
                    child: Text('placeholder'),
                  ); // Or some other placeholder
                }
              },
            ),
          ),
        ),

        // New Expanded container for brightness slider and playback mode buttons to take up more width
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: <Widget>[
                // New row for brightness slider and playback mode buttons
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Slider(
                        value: _brightness,
                        min: 0.0,
                        max: 1.0,
                        divisions: 255,
                        onChanged: (double value) {
                          setState(() {
                            _brightness = value;
                          });
                          controlService
                              .sendRequest(brightnessUrl, "brightness",
                                  (_brightness * 100.0).toStringAsFixed(0))
                              .then((_) => controlService.fetchBrightness())
                              .then((value) =>
                                  setState(() => _brightness = value));
                        },
                      ),
                    ),
                    _repeatModeButton(),
                  ],
                ),

                // Existing buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "prev");
                      }, // Implement previous button functionality
                      icon: Icon(Icons.skip_previous),
                    ),
                    _playPauseButton(),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "stop");
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        controlService.sendRequest(
                            stateUrl, "state", "restart");
                      }, // Implement restart button functionality
                      icon: Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "next");
                      }, // Implement next button functionality
                      icon: Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ), // End of Expanded container
      ],
    );
  }
}
