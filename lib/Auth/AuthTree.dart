import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';
import 'Register.dart';

class AuthTreeWidget extends StatefulWidget {
  const AuthTreeWidget({super.key});

  @override
  _AuthTreeWidgetState createState() => _AuthTreeWidgetState();
}

class _AuthTreeWidgetState extends State<AuthTreeWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white38,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: BoxDecoration(color: const Color.fromRGBO(19, 22, 25, 100), image: DecorationImage(fit: BoxFit.fill, image: Image.asset('Assets/black1.png').image)),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
          child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Card(
                color: Colors.black,
                child: Image.asset(
                  'Assets/image1.png',
                  width: 234,
                  height: 234,
                  fit: BoxFit.fill,
                ).animate(autoPlay: true, effects: [
                  FadeEffect(curve: Curves.easeInOut, delay: 0.ms, duration: 600.ms, begin: 0, end: 1),
                  MoveEffect(curve: Curves.easeInOut, delay: 0.ms, duration: 600.ms, begin: const Offset(-0.0, 64), end: const Offset(0, 0)),
                  ScaleEffect(curve: Curves.easeInOut, delay: 0.ms, duration: 600.ms, begin: const Offset(1, 0), end: const Offset(1, 1)),
                ]),
              ),
            ])),
            Expanded(
              child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 20),
                        child: FloatingActionButton.extended(
                          heroTag: "heritage1",
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterWidget())),
                          label: Text("Register", style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: Colors.white)),
                          isExtended: true,
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 3,
                          backgroundColor: const Color(0xFF42BEA5),
                          extendedPadding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 50),
                          foregroundColor: const Color(0xFF42BEA5),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ).animate(autoPlay: true, effects: [
                          FadeEffect(curve: Curves.easeInOut, delay: 250.ms, duration: 600.ms, begin: 0, end: 1),
                          MoveEffect(curve: Curves.easeInOut, delay: 250.ms, duration: 600.ms, begin: const Offset(0, 64), end: const Offset(0, 0)),
                          ScaleEffect(curve: Curves.easeInOut, delay: 250.ms, duration: 600.ms, begin: const Offset(1, 0), end: const Offset(1, 1)),
                        ]),
                      ),
                      FloatingActionButton.extended(
                        heroTag: "heritage2",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWidget())),
                        label: Text("Login", style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: const Color(0xFF42BEA5))),
                        isExtended: true,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 3,
                        backgroundColor: Colors.white,
                        extendedPadding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 60),
                      ).animate(autoPlay: true, effects: [
                        FadeEffect(curve: Curves.easeInOut, delay: 420.ms, duration: 600.ms, begin: 0, end: 1),
                        MoveEffect(curve: Curves.easeInOut, delay: 420.ms, duration: 600.ms, begin: const Offset(0, 74), end: const Offset(0, 0)),
                        ScaleEffect(curve: Curves.easeInOut, delay: 420.ms, duration: 600.ms, begin: const Offset(1, 0), end: const Offset(1, 1)),
                      ])
                    ]),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
