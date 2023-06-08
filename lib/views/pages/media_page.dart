import 'package:flutter/material.dart';
import '../widgets/playlist_widget.dart';
import '../widgets/media_files_widget.dart';

class MediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PlaylistWidget(),
            flex: 1,
          ),
          Divider(
            color: Colors.black38,
          ),
          Expanded(
            child: MediaFilesWidget(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
