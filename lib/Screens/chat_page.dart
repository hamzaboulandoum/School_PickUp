import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//We will add the chat functionnalities here afterwards

class Chat_Page extends StatefulWidget {
  const Chat_Page({Key? key}) : super(key: key);

  @override
  _Chat_PageState createState() => _Chat_PageState();
}

class _Chat_PageState extends State<Chat_Page> {
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
