import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'calcule.dart';
import 'constants.dart';
import 'custom_classes.dart' as cc;

class MapState extends StatefulWidget {
  final cc.Route route;
  const MapState({Key? key, required this.route}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapState> {
  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};
  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.5730, -7.5943),
    zoom: 15,
  );

  @override
  void initState() {
    /// add origin marker origin marker

    var route = widget.route;
    for (var item in route.sequence) {
      if (item == 0) {
        _addMarker(
          LatLng(myList[item][0], myList[item][1]),
          "${item}",
          BitmapDescriptor.defaultMarkerWithHue(120.0),
        );
        continue;
      }
      _addMarker(
        LatLng(myList[item][0], myList[item][1]),
        "${item}",
        BitmapDescriptor.defaultMarker,
      );
    }
    draw(route);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 20,
            child: Container(
              child: Text(
                  "Distance : ${widget.route.length.toStringAsFixed(2)} km  Durée : ${((widget.route.length / 14) * 60).toStringAsFixed(2)} mins"),
              color: Colors.white,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates, int i, Color color) {
    PolylineId id = PolylineId(
      "${i}",
    );
    Polyline polyline = Polyline(
      color: color,
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  void _drawRoute(List resulte, List<List<List<LatLng>>> PolylineMatrix) {
    for (var i = 0; i < resulte.length - 1; i++) {
      var polylineCoordinates = PolylineMatrix[resulte[i]][resulte[i + 1]];
      _addPolyLine(polylineCoordinates, i, Colors.green);
    }
    setState(() {});
  }

  void draw(route) async {
    List<List<List<LatLng>>> PolylineMatrix = await getPolylineMatrix(nb);
    _drawRoute(route.sequence, PolylineMatrix);
  }
}
