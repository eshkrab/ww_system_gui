import 'media.dart';

class Player {
  List<Media> playlist = [];
  String state = '';
  String mode = '';
  double brightness = 0;
  double fps = 0;

  Player({
    required this.playlist,
    required this.state,
    required this.mode,
    required this.brightness,
    required this.fps,
  });

  Player.fromJson(Map<String, dynamic> json) {
    if (json['playlist'] != null) {
      playlist = [];
      json['playlist'].forEach((v) {
        playlist.add(new Media.fromJson(v));
      });
    }
    state = json['state'];
    mode = json['mode'];
    brightness = json['brightness'];
    fps = json['fps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['mode'] = this.mode;
    data['brightness'] = this.brightness;
    data['fps'] = this.fps;
    if (this.playlist != null) {
      data['playlist'] = this.playlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
