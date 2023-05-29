import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/playlist_widget.dart';
import '../widgets/media_files_widget.dart';
import '../../view_models/player_view_model.dart';
import '../../view_models/media_view_model.dart';

class MediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<PlayerViewModel>(
    //       create: (_) => PlayerViewModel(playerApiService: PlayerApiService()),
    //     ),
    //     ChangeNotifierProvider<MediaViewModel>(
    //       create: (_) => MediaViewModel(mediaApiService: MediaApiService()),
    //     ),
    //   ],
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
