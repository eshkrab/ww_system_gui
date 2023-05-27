class Media {
  String filename = '';
  String? thumbnail = '';

  Media({
    required this.filename,
    this.thumbnail,
  });

  Media.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
