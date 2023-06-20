import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/media_provider.dart';
import '../../models/media.dart';

class PlaylistWidget extends StatefulWidget {
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  bool _editing = false;
  Future<void>? _fetchPlaylistFuture;

  @override
  void initState() {
    super.initState();
    _fetchPlaylistFuture =
        Provider.of<PlaylistProvider>(context, listen: false).fetchPlaylist();
  }

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    var playlistProvider = Provider.of<PlaylistProvider>(context);
    var mediaFileProvider = Provider.of<MediaFileProvider>(context);

    return FutureBuilder(
      future: _fetchPlaylistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred!'));
        } else {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_editing)
                      ElevatedButton(
                        onPressed: () async {
                          // Confirm delete
                          bool confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text(
                                        "Are you sure you want to delete all items from the playlist?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete All"),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ) ??
                              false;

                          if (confirm) {
                            playlistProvider.clearPlaylist();

                            if (playlistProvider.playlist.playlist.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete items'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Delete All'),
                      ),
                    // ... other UI elements ...
                    Spacer(),
                    if (_editing)
                      //spacer
                      DropdownButton<MediaFile>(
                        hint: Text("Select Media"),
                        onChanged: (MediaFile? mediaFile) {
                          if (mediaFile != null) {
                            playlistProvider.addItem(mediaFile);
                          }
                        },
                        items: mediaFileProvider.mediaFiles
                            .map((MediaFile mediaFile) {
                          return DropdownMenuItem<MediaFile>(
                            value: mediaFile,
                            child: Text(mediaFile.name),
                          );
                        }).toList(),
                      ),
                    Spacer(),
                    TextButton(
                      onPressed: _toggleEditing,
                      child: Text(_editing ? 'Done' : 'Edit'),
                    ),
                    if (_editing)
                      TextButton(
                        onPressed: () async {
                          if (playlistProvider.playlist.playlist.isNotEmpty) {
                            await playlistProvider.savePlaylist();
                            _toggleEditing();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Playlist cannot be empty.'),
                              ),
                            );
                          }
                        },
                        child: Text('Save'), // Changing Done to Save
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: _editing
                      ? ReorderableListView.builder(
                          itemCount: playlistProvider.playlist.playlist.length,
                          onReorder: (int oldIndex, int newIndex) {
                            playlistProvider.reorderItems(oldIndex, newIndex);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                playlistProvider.playlist.playlist[index].name;
                            return ListTile(
                              key: Key('$item-$index'),
                              title: Text(item),
                              tileColor: index % 2 == 0
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.5)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.1),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    playlistProvider.deleteItem(index),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: playlistProvider.playlist.playlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                playlistProvider.playlist.playlist[index].name;
                            return ListTile(
                              title: Text(item),
                              tileColor: index % 2 == 0
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.5)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.1),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
