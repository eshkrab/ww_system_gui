import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/media_provider.dart';
import '../../models/media.dart';

class MediaFilesWidget extends StatefulWidget {
  @override
  _MediaFilesWidgetState createState() => _MediaFilesWidgetState();
}

class _MediaFilesWidgetState extends State<MediaFilesWidget> {
  bool _editing = false;
  Future<void>? _fetchMediaFilesFuture;

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMediaFilesFuture =
        Provider.of<MediaFileProvider>(context, listen: false)
            .fetchMediaFiles();
  }

  @override
  Widget build(BuildContext context) {
    var mediaFileProvider = Provider.of<MediaFileProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        const Text(
          'Media Files',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );

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

                    await mediaFileProvider.uploadMedia(result);

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
              Row(
                children: [
                  if (_editing)
                    ElevatedButton(
                      onPressed: () async {
                        // Confirm delete
                        bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete All"),
                                  content: Text(
                                      "Are you sure you want to delete all media files?"),
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
                          await mediaFileProvider.deleteAllItems();

                          if (mediaFileProvider.mediaFiles.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete files'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Delete All'),
                    ),
                  TextButton(
                    onPressed: _toggleEditing,
                    child: Text(_editing ? 'Done' : 'Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ListView.builder(
              itemCount: mediaFileProvider.mediaFiles.length,
              itemBuilder: (BuildContext context, int index) {
                final item = mediaFileProvider.mediaFiles[index].name;
                return ListTile(
                  title: Text(item),
                  tileColor: index % 2 == 0
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                      : Theme.of(context).colorScheme.surface.withOpacity(0.1),
                  trailing: _editing
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => mediaFileProvider.deleteItem(index),
                        )
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
