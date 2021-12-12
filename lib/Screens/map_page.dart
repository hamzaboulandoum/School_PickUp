import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// We will add the google maps here  afterwards

class Maps_page extends StatefulWidget {
  const Maps_page({Key? key}) : super(key: key);

  @override
  _Maps_pageState createState() => _Maps_pageState();
}

class _Maps_pageState extends State<Maps_page> {
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
                  'Maps',
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
