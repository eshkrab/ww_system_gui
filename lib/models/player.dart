class Player {
  String state = '';
  double brightness = 0;
  double fps = 0;

  Player({
    required this.state,
    required this.brightness,
    required this.fps,
  });

  Player copyWith({
    String? state,
    double? brightness,
    double? fps,
  }) {
    return Player(
      state: state ?? this.state,
      brightness: brightness ?? this.brightness,
      fps: fps ?? this.fps,
    );
  }

  Player.fromJson(Map<String, dynamic> json) {
    // if (json['playlist'] != null) {
    //   playlist = [];
    //   json['playlist'].forEach((v) {
    //     playlist.add(new Media.fromJson(v));
    //   });
    // }

    state = json['state'];
    brightness = json['brightness'];
    fps = json['fps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['state'] = state;
    data['brightness'] = brightness;
    data['fps'] = fps;
    // if (playlist != null) {
    //   data['playlist'] = playlist.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
