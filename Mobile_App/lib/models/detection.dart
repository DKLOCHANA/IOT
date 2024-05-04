// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_this
import 'dart:convert';

class Detections {
  final String detectedDate;
  final String detectedTime;
  final String distance;
  final String comment;
  final String location;
  final String username;
  final String longitude;
  final String latitude;
  Detections({
    required this.detectedDate,
    required this.detectedTime,
    required this.distance,
    required this.comment,
    required this.location,
    required this.username,
    required this.longitude,
    required this.latitude,

  });

  Detections copyWith({
    String? detectedDate,
    String? detectedTime,
    String? distance,
    String? comment,
    String? location,
    String? username,
    String? longitude,
    String? latitude,
  }) {
    return Detections(
      detectedDate: detectedDate ?? this.detectedDate,
      detectedTime: detectedTime ?? this.detectedTime,
      distance: distance ?? this.distance,
      comment: comment ?? this.comment,
      location: location ?? this.location,
      username: username ?? this.username,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'detectedDate': detectedDate,
      'detectedTime': detectedTime,
      'distance': distance,
      'comment': comment,
      'location': location,
      'username': username,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Detections.fromMap(Map<String, dynamic> map) {
    return Detections(
      detectedDate: map['detected_date'] as String,
      detectedTime: map['detected_time'] as String,
      distance: map['distance'] as String,
      comment: map['comment'] as String,
      location: map['location'] as String,
      username: map['username'] as String,
      longitude: map['longitude'] as String,
      latitude: map['latitude'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Detections.fromJson(String source) =>
      Detections.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Detections(detectedDate: $detectedDate, detectedTime: $detectedTime, distance: $distance, comment: $comment, location: $location, username: $username, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(covariant Detections other) {
    if (identical(this, other)) return true;

    return other.detectedDate == detectedDate &&
        other.detectedTime == detectedTime &&
        other.distance == distance &&
        other.location == location &&
        other.username == username &&
        other.comment == comment &&
        other.longitude == longitude &&
        other.latitude == latitude;

  }

  @override
  int get hashCode {
    return detectedDate.hashCode ^
        detectedTime.hashCode ^
        distance.hashCode ^
        comment.hashCode;
        //location.hashCode;
  }
}
