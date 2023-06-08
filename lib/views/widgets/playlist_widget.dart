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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ... other UI elements ...
                    if (_editing)
                      DropdownButton<MediaFile>(
                        hint: Text("Add Media"),
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
                    TextButton(
                      onPressed: _toggleEditing,
                      child: Text(_editing ? 'Cancel' : 'Edit'),
                    ),
                    if (_editing)
                      TextButton(
                        onPressed: () async {
                          await playlistProvider.savePlaylist(
                              playlistProvider.playlist.playlist,
                              playlistProvider.playlist.mode);
                          _toggleEditing();
                        },
                        child: Text('Save'),
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
                              tileColor: index % 2 == 0
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.5)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.1),
                              title: Text(item),
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
