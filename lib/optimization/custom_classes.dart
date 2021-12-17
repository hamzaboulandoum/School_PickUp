class Geopoint{
  int name=0;
  num x;
  num y;
  Geopoint({this.x = 0,this.y=0,this.name = 0});
}

class Route{
  double length = 0;
  var sequence = [0];
  void addGeopoint(int n){
    sequence.add(n);
  }
}

class Graph{
  //var geopodoubles = [];
  var matrix;
  Graph({required this.matrix});
  
}