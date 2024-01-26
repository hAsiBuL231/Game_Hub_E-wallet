import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LevelMemberWidget extends StatefulWidget {
  const LevelMemberWidget({super.key});

  @override
  State<LevelMemberWidget> createState() => _LevelMemberWidgetState();
}

class _LevelMemberWidgetState extends State<LevelMemberWidget> {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.blue], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: RichText(
                softWrap: true,
                text: const TextSpan(children: <TextSpan>[
                  TextSpan(text: 'Level Member', style: TextStyle(fontSize: 24, color: Colors.white)),
                  TextSpan(text: '  List', style: TextStyle(fontSize: 24, color: Colors.black)),
                ]))),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user_list').doc(userEmail).snapshots(),
          builder: (context, snapshot) {
            var data = snapshot.data!.data();
            List count = data!["Level Count"];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView.builder(
                  itemCount: count.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int counts = count[index];
                    return Card(
                        margin: const EdgeInsets.all(2),
                        color: Colors.red,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.white, width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text("Level ${index +1}:   $counts Member", softWrap: true, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
