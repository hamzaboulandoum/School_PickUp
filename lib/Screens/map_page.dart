import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MapTemporary extends StatefulWidget {
  const MapTemporary({Key? key}) : super(key: key);

  @override
  _MapTemporaryState createState() => _MapTemporaryState();
}

class _MapTemporaryState extends State<MapTemporary> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x665ac18e),
                    Color(0x995ac18e),
                    Color(0xcc5ac18e),
                    Color(0xff5ac18e),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
