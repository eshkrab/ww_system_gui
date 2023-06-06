import 'media.dart';

class Playlist {
  List<MediaFile> playlist = [];
  String mode = '';

  Playlist({
    required this.playlist,
    required this.mode,
  });

  Playlist.fromJson(Map<String, dynamic> json)
      : playlist = (json['playlist'] as List<dynamic>)
            .map((e) => MediaFile.fromJson(e))
            .toList(),
        mode = json['mode'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mode'] = mode;
    if (playlist.isNotEmpty) {
      data['playlist'] = playlist.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Playlist copyWith({
    List<MediaFile>? playlist,
    String? mode,
  }) {
    return Playlist(
      playlist: playlist ?? this.playlist,
      mode: mode ?? this.mode,
    );
  }
}
