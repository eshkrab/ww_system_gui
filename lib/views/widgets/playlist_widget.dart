import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:provider/provider.dart';
import '../../view_models/player_view_model.dart';

class PlaylistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playlistViewModel =
        Provider.of<PlaylistViewModel>(context, listen: false);

    return Consumer<PlaylistViewModel>(
      builder: (context, model, child) => Column(
        children: [
          ElevatedButton(
            onPressed: () {
              model.toggleEditMode();
            },
            child: Text(model.isEditMode ? 'Save Changes' : 'Edit Playlist'),
          ),
          Expanded(
            child: ReorderableList(
              onReorder: model.isEditMode ? model.movePlaylistItem : null,
              child: ListView.builder(
                itemCount: model.playlistItems.length,
                itemBuilder: (context, index) {
                  return ReorderableItem(
                    key: Key(model.playlistItems[index].title),
                    childBuilder:
                        (BuildContext context, ReorderableItemState state) {
                      return ListTile(
                        tileColor: index % 2 == 0
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.primaryVariant,
                        title: Text(model.playlistItems[index].title),
                        trailing: model.isEditMode
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  model.deletePlaylistItem(index);
                                },
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          model.isEditMode
              ? DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.1,
                  maxChildSize: 0.6,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      color: Colors.blue[100],
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: model.mediaItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(model.mediaItems[index].title),
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                model.addMediaItemToPlaylist(index);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
