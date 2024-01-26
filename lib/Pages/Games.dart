import 'package:flutter/material.dart';

class GamePageWidget extends StatelessWidget {
  const GamePageWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            foregroundColor: Colors.black,
            title: RichText(
                softWrap: true,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: title, style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' Page', style: TextStyle(fontSize: 24, color: Color(0xFF016DF7), fontWeight: FontWeight.bold)),
                ]))),
        body: Center(
          child: RichText(
              softWrap: true,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(text: 'Coming', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                TextSpan(text: ' Soon', style: TextStyle(fontSize: 24, color: Color(0xFF016DF7), fontWeight: FontWeight.bold))
              ])),
        ),
      ),
    );
  }
}
