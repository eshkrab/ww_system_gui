import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<String> _playlist = [];
  List<String> _videoDirectory = [];
  String? _selectedVideo;
  String _playbackMode = "LOOP";

  bool _editing = false;
  bool _editingVideoDirectory = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaylist();
    _fetchVideoDirectory();
  }

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
    });
  }

  void _toggleVideoDirectoryEditing() {
    setState(() {
      _editingVideoDirectory = !_editingVideoDirectory;
    });
  }

  Future<void> _fetchVideoDirectory() async {
    final response =
        await http.get(Uri.parse('http://192.168.86.22:5000/api/videos'));

    if (response.statusCode == 200) {
      setState(() {
        _videoDirectory =
            List<String>.from(jsonDecode(response.body)['videos']);
      });
    } else {
      throw Exception('Failed to load video directory');
    }
  }

  Future<void> _uploadVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['mp4', 'avi', 'mov']);

    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      String fileName = result.files.single.name;

      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );

      FormData formData = FormData.fromMap({'file': multipartFile});

      // Create a Dio instance
      Dio dio = Dio();

      try {
        var response = await dio.post(
            'http://192.168.86.22:5000/api/videos/upload',
            data: formData);
        if (response.statusCode == 200 && response.data['success'] == true) {
          print('Video uploaded successfully');
          // Refetch the video directory after uploading the video
          _fetchVideoDirectory();
        } else {
          print('Failed to upload video');
        }
      } catch (e) {
        print('Error while uploading video: $e');
      }
    } else {
      print('No file selected');
    }
  }

  Future<bool?> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Video'),
          content: Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVideo(String filename) async {
    bool? shouldDelete = await _showDeleteConfirmationDialog();
    if (shouldDelete == true) {
      final response = await http.post(
        Uri.parse('http://192.168.86.22:5000/api/videos/delete'),
        body: {'filename': filename},
      );

      if (response.statusCode == 200) {
        setState(() {
          _videoDirectory.remove(filename);
        });
      } else {
        throw Exception('Failed to delete video');
      }
    }
  }

  Future<void> _fetchPlaylist() async {
    // Replace 'localhost' with your server's IP address or domain name
    final response =
        await http.get(Uri.parse('http://192.168.86.22:5000/api/playlist'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _playlist = List<String>.from(data['playlist']);
        _playbackMode = data['mode'];
      });
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<void> _savePlaylist() async {
    // Replace 'localhost' with your server's IP address or domain name
    final response = await http.post(
      Uri.parse('http://192.168.86.22:5000/api/playlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'playlist': _playlist, 'mode': _playbackMode}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save playlist');
    } else {
      _toggleEditing(); //Exit editing mode after saving
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _playlist.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      String item = _playlist.removeAt(oldIndex);
      _playlist.insert(newIndex, item);
    });
  }

  Widget _buildPlaybackMode() {
    if (_editing) {
      return Row(children: <Widget>[
        Text('Playback Mode:  '),
        DropdownButton<String>(
          value: _playbackMode,
          items: ['LOOP', 'HOLD', 'ZERO'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _playbackMode = newValue!;
            });
          },
        ),
      ]);
    } else {
      return Text('Playback Mode: $_playbackMode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          'Playlist',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPlaybackMode(),
              SizedBox(width: 10),
              if (_editing)
                TextButton(
                  onPressed: _savePlaylist,
                  child: Text('Save'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.white,
                  ),
                ),
              // Add upload and delete buttons here
              SizedBox(width: 10),
              TextButton(
                onPressed: _toggleEditing,
                child: Text(_editing ? 'Cancel' : 'Edit'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  primary: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: _editing
                ? ReorderableListView.builder(
                    itemCount: _playlist.length,
                    onReorder: (int oldIndex, int newIndex) {
                      if (_editing) _onReorder(oldIndex, newIndex);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final item = _playlist[index];
                      return Container(
                        key: ValueKey(item),
                        color: index % 2 == 0
                            ? Colors.grey[200]
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteItem(index),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: _playlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _playlist[index];
                      return Container(
                        color: index % 2 == 0
                            ? Colors.grey[200]
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(item),
                        ),
                      );
                    },
                  ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Video Directory',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _uploadVideo,
                child: Text('Upload'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  primary: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: _toggleVideoDirectoryEditing,
                child: Text(_editingVideoDirectory ? 'Done' : 'Edit'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  primary: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ListView.builder(
              itemCount: _videoDirectory.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_videoDirectory[index]),
                  trailing: _editingVideoDirectory
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteVideo(_videoDirectory[index]),
                        )
                      : null,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
