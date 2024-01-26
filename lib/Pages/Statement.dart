import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatementsWidget extends StatefulWidget {
  const StatementsWidget({super.key});

  @override
  State<StatementsWidget> createState() => _StatementsWidgetState();
}

class _StatementsWidgetState extends State<StatementsWidget> {
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
                  TextSpan(text: 'Statement ', style: TextStyle(fontSize: 24, color: Colors.white)),
                  TextSpan(text: 'Page', style: TextStyle(fontSize: 24, color: Colors.black)),
                ]))),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').orderBy('time', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Some data is missing'));
                }
                var docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Map map = {};
                    var data = docs.elementAt(index);
                    int amount = data['amount'];
                    String status = data['status'];
                    String type = data['type'];

                    return Card(
                      margin: const EdgeInsets.all(2),
                      color: Colors.red,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.white, width: 3)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max, children: [
                          //Text('No: ${index + 1}   =>   $type: $amount     Status: $status'),
                          /*Text("No: ${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),*/
                          Column(children: [
                            Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Status: $status", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ]),
                          Text("$amount", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
