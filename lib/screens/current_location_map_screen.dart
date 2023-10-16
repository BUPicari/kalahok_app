import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class CurrentLocationMapScreen extends StatefulWidget {
  const CurrentLocationMapScreen({Key? key,}) : super(key: key);

  @override
  State<CurrentLocationMapScreen> createState() => _CurrentLocationMapScreenState();
}

class _CurrentLocationMapScreenState extends State<CurrentLocationMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location")),
      body: FlutterMap(
        options: MapOptions(
          zoom: 15,
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            maxZoom: 19,
          ),
          CurrentLocationLayer(
            followOnLocationUpdate: FollowOnLocationUpdate.always,
            turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(
                  Icons.pin_drop,
                  color: Colors.white,
                ),
              ),
              markerSize: Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ), // <-- add layer here
        ],
      ),
    );
  }
}
