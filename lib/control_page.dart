import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trophy_gui/settings_page.dart';
import 'package:trophy_gui/control_service.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // VideoService video_service = context.read<VideoService>();
  late ControlService controlService;
  late SettingsProvider settingsProvider;

  String get brightnessUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/brightness';
  String get stateUrl =>
      'http://${settingsProvider.settings.serverIP}:${settingsProvider.settings.serverPort}/api/state';

  String _playbackMode = 'loop'; // Default playback mode
  double _brightness = 0; // Default brightness (Range: 0.0 - 1.0)

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   controlService = context.read<ControlService>();
    //   settingsProvider = context.watch<SettingsProvider>();
    //   controlService.fetchBrightness().then((value) {
    //     setState(() {
    //       _brightness = value;
    //     });
    //   });
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Image/Video area
        Expanded(
          child: Container(
              // Add your image or video widget here.
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
