import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final String apiUrl = "http://192.168.86.22:5000/api/state";
  late IO.Socket socket;
  Uint8List? _bytes;
  ui.Image? _image;

  Image _placeholderImage = Image.asset('placeholder.png');

  set _imageSetter(ui.Image? value) {
    setState(() {
      _image = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }

  void _connect() {
    socket = IO.io('http://192.168.86.22:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected');
    });

    socket.on('disconnect', (_) {
      print('Disconnected');
    });
    socket.on('frame', (data) {
      final byteList = data.cast<int>();

      ui.decodeImageFromList(byteList).then((image) {
        _imageSetter(image);
      });
    });

    socket.on('frame', (data) {
      final byteList = data.cast<int>();

      ui.decodeImageFromList(byteList).then((image) {
        _imageSetter = image;
      });
    });

    // socket.on('frame', (data) {
    //   final byteList = data.cast<int>();
    //   setState(() {
    //     _bytes = Uint8List.fromList(byteList);
    //   });
    // });

    socket.connect();
  }

  void _disconnect() {
    if (socket != null) {
      socket.disconnect();
    }
  }

  Future<String> sendRequest(String state) async {
    var response = await http.post(Uri.parse(apiUrl), body: {"state": state});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to send request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            sendRequest("start");
          },
        ),
        IconButton(
          icon: Icon(Icons.pause),
          onPressed: () {
            sendRequest("pause");
          },
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () {
            sendRequest("stop");
          },
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 320,
                height: 240,
                // child: _placeholderImage,
                child: _bytes != null
                    ? Image.memory(_bytes!, fit: BoxFit.cover)
                    : _placeholderImage,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _connect,
                child: Text('Connect'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _disconnect,
                child: Text('Disconnect'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
