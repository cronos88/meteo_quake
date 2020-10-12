class SismoModel {
  final double magnitude, longitude, latitude, depth;
  final int time, tsunami;
  final String place, magType;

  SismoModel(
      {this.magnitude,
      this.longitude,
      this.latitude,
      this.depth,
      this.time,
      this.tsunami,
      this.place,
      this.magType});

  static SismoModel fromJson(Map<String, dynamic> json) {
    return SismoModel(
        magnitude: json['properties']['mag'].toDouble(),
        longitude: json['geometry']['coordinates'][0].toDouble(),
        latitude: json['geometry']['coordinates'][1].toDouble(),
        depth: json['geometry']['coordinates'][2].toDouble(),
        time: json['properties']['time'],
        tsunami: json['properties']['tsunami'],
        place: json['properties']['place'],
        magType: json['properties']['magType']);
  }
}
