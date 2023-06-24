import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/playlist_widget.dart';
import '../widgets/media_files_widget.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/media_provider.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

// class _MediaPageState extends State<MediaPage>
//     with AutomaticKeepAliveClientMixin<MediaPage> {
class _MediaPageState extends State<MediaPage> {
  // @override
  // bool get wantKeepAlive => true;

  Future<void> _refreshMediaData(BuildContext context) {
    // You'll need to provide the way how your widgets refresh their data
    // Typically, this should include calls to some methods like `fetchMediaFiles()`, `fetchPlaylist()`, etc.
    // It should return a Future
    // For example:
    return Future.wait([
      Provider.of<MediaFileProvider>(context, listen: false).fetchMediaFiles(),
      Provider.of<PlaylistProvider>(context, listen: false).fetchPlaylist(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); // needed because of AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshMediaData(context),
        child: Column(
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
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../widgets/playlist_widget.dart';
// import '../widgets/media_files_widget.dart';
//
// class MediaPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Page'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PlaylistWidget(),
//             flex: 1,
//           ),
//           Divider(
//             color: Colors.black38,
//           ),
//           Expanded(
//             child: MediaFilesWidget(),
//             flex: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
