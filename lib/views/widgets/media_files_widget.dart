import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../models/media.dart';
import '../../providers/media_provider.dart';

class MediaFilesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MediaFileProvider>(
      builder: (context, mediaFileProvider, child) => Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.video);

              if (result != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Uploading..."),
                          ),
                        ],
                      ),
                    );
                  },
                );

                await mediaFileProvider.uploadMedia();

                Navigator.pop(context); // Close loading dialog

                if (mediaFileProvider.mediaFiles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload media')),
                  );
                }
              }
            },
            child: Text('Upload Media'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mediaFileProvider.mediaFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: index % 2 == 0
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.primaryVariant,
                  title: Text(mediaFileProvider.mediaFiles[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Confirm delete
                      bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text(
                                    "Are you sure you want to delete this media file?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
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
                        await mediaFileProvider.deleteMedia(
                            mediaFileProvider.mediaFiles[index].name);

                        if (mediaFileProvider.mediaFiles.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete media')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
