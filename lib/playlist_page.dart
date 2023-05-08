import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<String> _playlist = [];
  String? _selectedVideo;

  @override
  void initState() {
    super.initState();
    _fetchPlaylist();
  }

  Future<void> _fetchPlaylist() async {
    // Replace 'localhost' with your server's IP address or domain name
    final response =
        await http.get(Uri.parse('http://192.168.86.22:5000/api/playlist'));

    if (response.statusCode == 200) {
      setState(() {
        _playlist = List<String>.from(jsonDecode(response.body)['playlist']);
      });
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  // Implement the remaining APIs for edit, save, upload, and delete

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _playlist.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_playlist[index]),
                onTap: () {
                  setState(() {
                    _selectedVideo = _playlist[index];
                  });
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add edit and save buttons here
            // Add upload and delete buttons here
          ],
        ),
      ],
    );
  }
}
