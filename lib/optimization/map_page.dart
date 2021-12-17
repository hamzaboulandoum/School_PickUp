import 'package:e_shcool_bus/optimization/calcule.dart';
import 'package:e_shcool_bus/optimization/map_state.dart';
import 'package:flutter/material.dart';
import 'calcule.dart';
import 'map_state.dart';
import 'constants.dart';

class MapPage extends StatefulWidget {
  int nombreBus;
  MapPage({Key? key, required this.nombreBus}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //Variables
  int currentIndex = 0;
  List<int> bus = [];
  List<int> getBus(int nb, int nombreBus) {
    List<int> bus = [];
    int division = nb ~/ nombreBus;
    int rest = nb % nombreBus;
    for (var i = 0; i < nombreBus; i++) {
      if (rest > 0) {
        bus.add(division + 1);
        rest -= 1;
        continue;
      }
      bus.add(division);
    }
    return bus;
  }

  List<BottomNavigationBarItem> getBottomNavigationItems(int busnumbertouse) {
    List<BottomNavigationBarItem> bottomNavigationItems = [];
    for (int i = 0; i < busnumbertouse; i++) {
      bottomNavigationItems.add(const BottomNavigationBarItem(
        backgroundColor: Colors.green,
        icon: Icon(Icons.location_on),
        label: "Map",
      ));
    }
    return bottomNavigationItems;
  }

  @override
  Widget build(BuildContext context) {
    bus = getBus(nb - 1, widget.nombreBus);
    return FutureBuilder(
      future: mainu(bus),
      builder: (BuildContext context, AsyncSnapshot<List<MapState>> mapStates) {
        if (!mapStates.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        //List<MapState> _mapStates = mapStates.data!;
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.green,
            fixedColor: Colors.white,
            iconSize: 25,
            showUnselectedLabels: false,
            onTap: (index) => setState(
              () {
                currentIndex = index;
              },
            ),
            currentIndex: currentIndex,
            items: getBottomNavigationItems(widget.nombreBus),
          ),
          body: IndexedStack(
            index: currentIndex,
            children: mapStates.data!,
          ),
        );
      },
    );
  }
}
