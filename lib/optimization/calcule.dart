import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:e_shcool_bus/optimization/map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'constants.dart';
import 'ant_colony2.dart';
import 'custom_classes.dart' as cc;

PolylinePoints polylinePoints = PolylinePoints();
Future<List<List<List<LatLng>>>> getPolylineMatrix(int nb) async {
  List<List<List<LatLng>>> PolylineMatrix =
      List.generate(nb, (_) => List.generate(nb, (index) => []));
  for (var i = 0; i < nb; i++) {
    for (var j = 0; j < i; j++) {
      if (i != j) {
        List<LatLng> polylineCoordinates = [];

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyAMacbzICw-DlAMZvkYW4bh_mJMKC7h8-A",
          PointLatLng(myList[i][0], myList[i][1]),
          PointLatLng(myList[j][0], myList[j][1]),
          travelMode: TravelMode.driving,
        );
        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        } else {
          print(result.errorMessage);
        }
        PolylineMatrix[i][j] = polylineCoordinates;
        PolylineMatrix[j][i] = PolylineMatrix[i][j];
      }
    }
  }
  return PolylineMatrix;
}

Future<List<MapState>> mainu(List<int> bus) async {
  List<List<List<LatLng>>> PolylineMatrix = await getPolylineMatrix(nb);
  List<List<num>> matrix = genrateGraph(nb, myList, PolylineMatrix);
  cc.Graph g = cc.Graph(matrix: matrix);
  cc.Route route = antColony2(g, bus);
  List<MapState> mapStates = [];
  List<int> s = [0];
  double l = 0;
  for (var i = 1; i < route.sequence.length; i++) {
    s.add(route.sequence[i]);
    l += matrix[route.sequence[i - 1]][route.sequence[i]];
    if (route.sequence[i] == 0) {
      var r = cc.Route();
      r.sequence = s;
      r.length = l;
      mapStates.add(MapState(route: r));
      s = [0];
      l = 0;
    }
  }

  return mapStates;
}

List<List<num>> genrateGraph(
    int nb, List myList, List<List<List<LatLng>>> PolylineMatrix) {
  List<List<num>> matrix =
      List.generate(nb, (_) => List.generate(nb, (index) => 0));
  for (var i = 0; i < nb; i++) {
    for (var j = 0; j < i; j++) {
      if (i != j) {
        matrix[i][j] = distance(PolylineMatrix[i][j]);
        matrix[j][i] = matrix[i][j];
      }
    }
  }
  return matrix;
}

//calculate distance between 2 points //////////////////////////////////////////////////////:
double _coordinateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

num distance(polylineCoordinates) {
  double totalDistance = 0.0;
  for (int i = 0; i < polylineCoordinates.length - 1; i++) {
    totalDistance += _coordinateDistance(
      polylineCoordinates[i].latitude,
      polylineCoordinates[i].longitude,
      polylineCoordinates[i + 1].latitude,
      polylineCoordinates[i + 1].longitude,
    );
  }
  return totalDistance;
}
