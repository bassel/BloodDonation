import 'package:flutter/foundation.dart';

@immutable
class MedicalCenter {
  final String name;
  final List<String> phoneNumbers;
  final String location;
  final String latitude;
  final String longitude;

  const MedicalCenter({
    this.name,
    this.phoneNumbers,
    this.location,
    this.latitude,
    this.longitude,
  });

  MedicalCenter.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        phoneNumbers = List<String>.from(json['phoneNumbers'] as List),
        location = json['location'] as String,
        latitude = json['latitude'] as String,
        longitude = json['longitude'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumbers': phoneNumbers,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
      };
}
