import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/player_control_widget.dart';
import '../../providers/player_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/player_control_widget.dart';
import '../../providers/player_provider.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

// class _PlayerPageState extends State<PlayerPage>
//     with AutomaticKeepAliveClientMixin<PlayerPage> {
class _PlayerPageState extends State<PlayerPage> {
  late Future<void> _fetchPlayer;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshPlayerData(context);
  }

  Future<void> _refreshPlayerData(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    _fetchPlayer = Future.wait([
      playerProvider.fetchPlayerState(),
      playerProvider.fetchPlayerBrightness(),
      playerProvider.fetchPlayerFPS(),
      // playerProvider.fetchCurrentMediaFile(),
    ]);
    return _fetchPlayer;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); // needed because of AutomaticKeepAliveClientMixin
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPlayerData(context),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: _fetchPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('An error occurred!'));
              } else {
                return Consumer<PlayerProvider>(
                  builder: (context, model, child) => Column(
                    children: <Widget>[
                      // ThumbnailWidget(),
                      // if (model.player.currentMediaFile == null)
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 60),
                      //divider
                      Divider(
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      PlayerControlWidget(),
                      // Add here the widget for the WebSocket stream.
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// class ThumbnailWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final playerProvider = Provider.of<PlayerProvider>(context);
//
//     return FutureBuilder<String>(
//       future: playerProvider.fetchCurrentMediaFileThumbnailUrl(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             width: 100,
//             height: 100,
//             color: Colors.grey,
//           );
//         } else if (snapshot.hasError) {
//           return Container(
//             width: 100,
//             height: 100,
//             color: Colors.grey,
//           );
//         } else {
//           return Image.network(
//             snapshot.data!,
//             errorBuilder: (BuildContext context, Object exception,
//                 StackTrace? stackTrace) {
//               // Return an empty placeholder space
//               return Container(
//                 width: 100,
//                 height: 100,
//                 color: Colors.grey,
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
