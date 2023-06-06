import 'package:flutter/widgets.dart';

class MediaFile {
  String name;
  String filepath;
  String? thumbnail;
  Image? frame;

  MediaFile({
    required this.name,
    required this.filepath,
    this.thumbnail,
    this.frame,
  });

  MediaFile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        filepath = json['filepath'],
        thumbnail = json['thumbnail'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['filepath'] = filepath;
    data['name'] = name;
    data['thumbnail'] = thumbnail;
    return data;
  }

  MediaFile copyWith({
    String? name,
    String? filepath,
    String? thumbnail,
    Image? frame,
  }) {
    return MediaFile(
      name: name ?? this.name,
      filepath: filepath ?? this.filepath,
      thumbnail: thumbnail ?? this.thumbnail,
      frame: frame ?? this.frame,
    );
  }
}
