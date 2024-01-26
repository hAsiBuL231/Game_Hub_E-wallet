import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'All Functions Page/FirebaseFunction.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  late VideoPlayerController _controller;
  //bool _visible = false;

  @override
  void initState() {
    super.initState();

    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);*/

    _controller = VideoPlayerController.asset("Assets/splash_video.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(const Duration(seconds: 0), () {
        setState(() {
          _controller.play();
          //_visible = true;
          authentication(context);
        });
      });
    });

    /*Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => authentication(context)), (e) => false);
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _getVideoBackground() {
    return AnimatedOpacity(
        //opacity: _visible ? 1.0 : 0.0,
        opacity: 1,
        duration: const Duration(seconds: 3),
        child: VideoPlayer(_controller));
  }

  _getBackgroundColor() {
    return Container(color: Colors.transparent //.withAlpha(120),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Stack(children: [
                _getVideoBackground(),
              ]))),
    );
  }
}
