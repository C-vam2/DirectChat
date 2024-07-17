import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getCountryName() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  debugPrint('location: ${position.latitude}');

  var addresses =
      await placemarkFromCoordinates(position.longitude, position.latitude);
  var first = addresses.first;
  return first.country ?? "No country Found!!"; // this will return country name
}
