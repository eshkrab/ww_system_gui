import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:trophy_gui/settings_page.dart';
import 'package:trophy_gui/video_service.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:trophy_gui/video_service.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late VideoService videoService;
  late SettingsProvider settingsProvider;

  List<String> _playlist = [];
  List<String> _videoDirectory = [];
  String? _selectedVideo;
  String _playbackMode = "LOOP";
  Color? _altBgColor = Colors.transparent;

  bool _editing = false;
  bool _uploading = false;
  bool _editingVideoDirectory = false;

  @override
  void initState() {
    super.initState();
    // _fetchPlaylist();
    // _fetchVideoDirectory();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // listen to changes in theme brightness
  //   videoService = Provider.of<VideoService>(context, listen: false);
  //   settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  //
  //   List<String> playlist = await videoService.fetchPlaylist();
  //   setState(() {
  //     _playlist = playlist;
  //   });
  //   // videoService.fetchPlaylist().then((List<String> value) {
  //   //   setState(() {
  //   //     _playlist = value;
  //   //   });
  //   // }).catchError((error) {
  //   //   // handle error here
  //   // });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    videoService = Provider.of<VideoService>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    videoService.fetchPlaylist().then((List<String> value) {
      setState(() {
        _playlist = value;
      });
    }).catchError((error) {
      // handle error here
    });

    videoService.fetchVideoDirectory().then((List<String> value) {
      setState(() {
        _videoDirectory = value;
      });
    }).catchError((error) {
      // handle error here
    });

    final brightness = Theme.of(context).brightness;
    setState(() {
      _altBgColor =
          brightness == Brightness.light ? Colors.grey[200] : Colors.grey[700];
    });
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

  // Future<void> _fetchVideoDirectory() async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.86.22:5000/api/videos'));
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _videoDirectory =
  //           List<String>.from(jsonDecode(response.body)['videos']);
  //     });
  //   } else {
  //     throw Exception('Failed to load video directory');
  //   }
  // }
  //
  // Future<void> _uploadVideo() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['mp4', 'avi', 'mov']);
  //
  //   if (result != null) {
  //     Uint8List fileBytes = result.files.single.bytes!;
  //     String fileName = result.files.single.name;
  //
  //     MultipartFile multipartFile = MultipartFile.fromBytes(
  //       fileBytes,
  //       filename: fileName,
  //     );
  //
  //     FormData formData = FormData.fromMap({'file': multipartFile});
  //
  //     // Create a Dio instance
  //     Dio dio = Dio();
  //
  //     try {
  //       var response = await dio.post(
  //           'http://192.168.86.22:5000/api/videos/upload',
  //           data: formData);
  //       if (response.statusCode == 200 && response.data['success'] == true) {
  //         print('Video uploaded successfully');
  //         // Refetch the video directory after uploading the video
  //         _fetchVideoDirectory();
  //       } else {
  //         print('Failed to upload video');
  //       }
  //     } catch (e) {
  //       print('Error while uploading video: $e');
  //     }
  //   } else {
  //     print('No file selected');
  //   }
  // }

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

  // Future<void> _deleteVideo(String filename) async {
  //   bool? shouldDelete = await _showDeleteConfirmationDialog();
  //   if (shouldDelete == true) {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.86.22:5000/api/videos/delete'),
  //       body: {'filename': filename},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _videoDirectory.remove(filename);
  //       });
  //     } else {
  //       throw Exception('Failed to delete video');
  //     }
  //   }
  // }
  //
  // Future<void> _fetchPlaylist() async {
  //   // Replace 'localhost' with your server's IP address or domain name
  //   final response =
  //       await http.get(Uri.parse('http://192.168.86.22:5000/api/playlist'));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     setState(() {
  //       _playlist = List<String>.from(data['playlist']);
  //       _playbackMode = data['mode'];
  //     });
  //   } else {
  //     throw Exception('Failed to load playlist');
  //   }
  // }
  //
  // Future<void> _savePlaylist() async {
  //   // Replace 'localhost' with your server's IP address or domain name
  //   final response = await http.post(
  //     Uri.parse('http://192.168.86.22:5000/api/playlist'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'playlist': _playlist, 'mode': _playbackMode}),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to save playlist');
  //   } else {
  //     _fetchPlaylist();
  //     _toggleEditing(); //Exit editing mode after saving
  //   }
  // }

  void _addItem(String item) {
    setState(() {
      _playlist.add(item);
    });
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
        const SizedBox(height: 20),
        const Text(
          'Playlist',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPlaybackMode(),
              const SizedBox(width: 10),
              const SizedBox(width: 10),
              if (_editing)
                DropdownButton<String>(
                  hint: Text("Add Video"),
                  items: _videoDirectory.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _addItem(newValue);
                    }
                  },
                ),
              SizedBox(width: 10),
              if (_editing)
                TextButton(
                  onPressed: () async {
                    await videoService.savePlaylist(_playlist, _playbackMode);
                    videoService.fetchPlaylist();
                    _toggleEditing(); //Exit editing mode after saving
                  },
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
                        key: Key('$item-$index'),
                        color: Theme.of(context).brightness == Brightness.light
                            ? index % 2 == 0
                                ? _altBgColor
                                : Colors.transparent
                            : index % 2 == 0
                                ? _altBgColor
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? index % 2 == 0
                                ? _altBgColor
                                : Colors.transparent
                            : index % 2 == 0
                                ? _altBgColor
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
              Stack(
                children: [
                  _uploading
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            setState(() {
                              _uploading = true; // Set uploading status to true
                            });
                            try {
                              await videoService
                                  .uploadVideo(); // Call uploadVideo function
                              await videoService
                                  .fetchVideoDirectory()
                                  .then((List<String> value) {
                                setState(() {
                                  _videoDirectory = value;
                                });
                              });
                            } catch (e) {
                              print('Error uploading video: $e');
                            } finally {
                              setState(() {
                                _uploading =
                                    false; // Set uploading status to false
                              });
                            }
                          },
                          child: Text('Upload'),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white,
                          ),
                        ),
                ],
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
                          onPressed: () => {
                                videoService
                                    .deleteVideo(_videoDirectory[index]),
                                // videoService.fetchVideoDirectory(),
                                videoService
                                    .fetchVideoDirectory()
                                    .then((List<String> value) {
                                  setState(() {
                                    _videoDirectory = value;
                                  });
                                  // handle error here
                                }),
                              })
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
