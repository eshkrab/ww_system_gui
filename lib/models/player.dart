import './media.dart';
import './playlist.dart';

class Player {
  String state = '';
  double brightness = 0;
  double fps = 0;
  MediaFile? currentMediaFile;

  Player({
    required this.state,
    required this.brightness,
    required this.fps,
    this.currentMediaFile,
  });

  Player copyWith({
    String? state,
    double? brightness,
    double? fps,
    MediaFile? currentMediaFile,
  }) {
    return Player(
      state: state ?? this.state,
      brightness: brightness ?? this.brightness,
      fps: fps ?? this.fps,
      currentMediaFile: currentMediaFile ?? this.currentMediaFile,
    );
  }

  Player.fromJson(Map<String, dynamic> json) {
    brightness = json['brightness'];
    fps = json['fps'];
    currentMediaFile = json['currentMediaFile'] != null
        ? MediaFile.fromJson(json['currentMediaFile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['state'] = state;
    data['brightness'] = brightness;
    data['fps'] = fps;
    if (currentMediaFile != null) {
      data['currentMediaFile'] = currentMediaFile!.toJson();
    }
    return data;
  }
}
