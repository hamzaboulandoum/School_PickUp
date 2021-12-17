import 'dart:math';
import 'constants.dart';
import 'custom_classes.dart';

Route antColony1(Graph g) {
  Route bestRoute = generateRoute(g);
  print(bestRoute.length);
  double f;
  int c = 0;
  List<List<num>> auxformones =
      List.generate(nb, (_) => List.from(formones[_]));
  while (c != 200) {
    /*if (c%100==0) {
      k+=(c/1000);
    }*/

    for (int i = 0; i < auxformones.length; i++) {
      for (int j = 0; j < auxformones[0].length; j++) {
        auxformones[i][j] *= evaporationRate;
      }
    }
    for (var i = 0; i < b; i++) {
      Route r = generateRoute(g);
      f = r.length - bestRoute.length;
      if (f < 0) {
        bestRoute = r;
        c == 0;
        //k-=0.05;
      }

      for (int i = 0; i < r.sequence.length - 1; i++) {
        auxformones[r.sequence[i]][r.sequence[i + 1]] +=
            q / (r.length); //f.abs()+t or r.length
        auxformones[r.sequence[i + 1]][r.sequence[i]] += q / (r.length);
      }
    }

    formones = List.generate(nb, (_) => List.from(auxformones[_]));

    c++;
  }
  return bestRoute;
}

int random(Map<int, num> x) {
  var options = x.keys.toList();
  var weights = x.values.toList();
  int n = options.length;
  num r = Random().nextDouble();
  num s = 0;
  for (int i = 0; i < n; i++) {
    s += weights[i];
    if (r - s < 0) {
      return options[i];
    }
  }
  return -1;
}

Map<int, num> generateProbabilities(int i, List<int> available, Graph g) {
  Map<int, num> x = {};
  double s = 0;
  for (int j = 0; j < available.length; j++) {
    num a = pow(formones[i][available[j]], alpha) *
        pow(k / g.matrix[i][available[j]], beta);
    x[available[j]] = a;
    s += a;
  }
  for (int j = 0; j < available.length; j++) {
    num a = x[available[j]]! / s;
    x[available[j]] = a;
  }
  return x;
}

Route generateRoute(Graph g) {
  var r = Route();
  List<int> available = List.generate(nb - 1, (index) => index + 1);
  int i = 0;
  int j = 0;
  while (j < nb - 1) {
    var l = generateProbabilities(i, available, g);
    int next = random(l);
    r.addGeopoint(next);
    r.length += g.matrix[i][next];
    available.remove(next);
    i = next;
    j++;
  }
  r.addGeopoint(0);
  r.length += g.matrix[i][0];
  return r;
}
