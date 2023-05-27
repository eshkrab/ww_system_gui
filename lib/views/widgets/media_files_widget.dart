import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../view_models/media_view_model.dart';

class MediaFilesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaViewModel = Provider.of<MediaViewModel>(context, listen: false);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.video);

            if (result != null) {
              // Show loading dialog
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

              bool uploadSuccess =
                  await mediaViewModel.uploadMedia(result.files.single);

              Navigator.pop(context); // Close loading dialog

              if (!uploadSuccess) {
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
            itemCount: mediaViewModel.mediaFiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: index % 2 == 0
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.primaryVariant,
                title: Text(mediaViewModel.mediaFiles[index].name),
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
                      bool deleteSuccess = await mediaViewModel
                          .deleteMedia(mediaViewModel.mediaFiles[index]);

                      if (!deleteSuccess) {
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
    );
  }
}
