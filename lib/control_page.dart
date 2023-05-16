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
  // IO.Socket? socket;

  // Image _lastFrame;

  String get brightnessUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/brightness';
  String get stateUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/state';

  String _playbackMode = 'loop'; // Default playback mode
  double _brightness = 0; // Default brightness (Range: 0.0 - 1.0)

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
    // _timer = Timer.periodic(Duration(milliseconds: _frameInterval), (timer) {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
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

    // socket = IO.io(
    //     'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}');
    //
    // socket!.onConnect((_) {
    //   print('connected');
    // });
    //
    // socket!.on('frame', (data) {
    //   // Handle the received frame data
    //   // String encodedFrame = data;
    //   // Uint8List bytes = base64Decode(encodedFrame);
    //
    //   // Since you're updating the UI, make sure to run this in the main isolate
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     setState(() {
    //       // Assuming you have an Uint8List variable called _imageBytes to hold the image data
    //       _lastFrameBytes = _imageBytes;
    //       _imageBytes = data;
    //     });
    //   });
    // });
    //
    // socket!.connect();
  }

  @override
  void dispose() {
    // socket!.disconnect();
    super.dispose();
  }

  // Widget _displayImage(String base64String) {
  //   Uint8List bytes = base64Decode(base64String);
  //   // Now you can display the image using Image.memory
  //   // return Image.memory(bytes);
  //   // You'll need to insert this image widget into your widget tree.
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Image/Video area
        Expanded(
          child: Container(
            // Add your image or video widget here.
            child: StreamBuilder<Uint8List>(
              stream: _videoStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data ?? Uint8List(0));
                } else {
                  return CircularProgressIndicator(); // Or some other placeholder
                }
              },
            ),
          ),
        ),

        // New Expanded container for brightness slider and playback mode buttons to take up more width
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                // New row for brightness slider and playback mode buttons
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Slider(
                        value: _brightness,
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
                    IconButton(
                      icon: Icon(Icons.loop),
                      color:
                          _playbackMode == 'loop' ? Colors.green : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _playbackMode = 'loop';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.repeat_one),
                      color: _playbackMode == 'loop_one'
                          ? Colors.green
                          : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _playbackMode = 'loop_one';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      color:
                          _playbackMode == 'halt' ? Colors.green : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _playbackMode = 'halt';
                        });
                      },
                    ),
                  ],
                ),

                // Existing buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "start");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "pause");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        controlService.sendRequest(stateUrl, "state", "stop");
                      },
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

  // Future<void> sendRequest(String url, String f, String state) async {
  //   final response = await http.post(Uri.parse(url), body: {f: state});
  //   if (response.statusCode != 200) {
  //     print(response.body); // Add this line to log the response body
  //     throw Exception('Failed to send request');
  //   }
  // }
  //
  // Future<double> _getBrightness() async {
  //   final response = await http.get(Uri.parse(brightnessUrl));
  //   if (response.statusCode == 200) {
  //     // return double.parse(json.decode(response.body)["brightness"]);
  //     return json.decode(response.body)["brightness"].toDouble() / 100.0;
  //   } else {
  //     throw Exception('Failed to get brightness');
  //   }
  // }
}
