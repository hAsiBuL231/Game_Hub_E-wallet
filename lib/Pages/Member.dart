import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../All%20Functions%20Page/Functions.dart';
import '../Pages/LevelMembers.dart';

class OneLevelMember extends StatefulWidget {
  const OneLevelMember({super.key, required this.email});
  final String email;

  @override
  State<OneLevelMember> createState() => _OneLevelMemberState();
}

class _OneLevelMemberState extends State<OneLevelMember> {
  int memberCount = 0;

  getID() async {
    await FirebaseFirestore.instance.collection('user_list').get().then((value) {
      var data = value.docs.length;
      setState(() {
        memberCount = data;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }

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
                    TextSpan(text: 'Member', style: TextStyle(fontSize: 24, color: Colors.white)),
                    TextSpan(text: '  List', style: TextStyle(fontSize: 24, color: Colors.black)),
                  ]))),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.doc('user_list/${widget.email}').snapshots(),
                builder: (context, snapshot) {
                  var data = snapshot.data!.data();
                  List child = data!['Child List'];
                  List count = data['Count'];
                  int income = data['Income'];
                  if (child.isEmpty) {
                    return const Center(child: Text('No member added', style: TextStyle(fontSize: 18)));
                  }
                  return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      const Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.black54, width: 3)),
                          margin: EdgeInsets.all(6),
                          color: Colors.green,
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(' Total Member ', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)))),
                      Card(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.black54, width: 3)),
                          margin: const EdgeInsets.all(6),
                          color: Colors.deepPurple,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                              child: Text("0$memberCount", textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.white))))
                      //child: Text("0${child.length}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.white))))
                    ]),
                    FloatingActionButton.extended(
                        onPressed: () => nextPage(const LevelMemberWidget(), context),
                        label: const Text("See level members count", style: TextStyle(fontWeight: FontWeight.bold))),
                    const Center(
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.white, width: 3)),
                            margin: EdgeInsets.all(6),
                            color: Colors.amber,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Level one list', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white))))),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: child.length,
                        itemBuilder: (context, index) {
                          String user = child.elementAt(index);
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.doc('user_list/$user').snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: Text('Some data is missing'));
                              }
                              var data = snapshot.data!.data();
                              return InkWell(
                                onTap: () => nextPage(OneLevelMember(email: user), context),
                                child: Card(
                                    margin: const EdgeInsets.all(2),
                                    color: Colors.red,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Colors.white, width: 3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max, children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          //"  ${index + 1}. ${data!['User Name']},  ID: $userID ,  ${data['Phone']}",
                                          Text("Name: ${data!['User Name']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                          Text("Id: ${data["Unique ID"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                          Text("Mobile: 0${data['Phone']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                        ]),
                                        Row(mainAxisSize: MainAxisSize.min, children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 32),
                                          Card(
                                            color: Colors.amber,
                                            child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: Text('0${data['Star']}',
                                                    textAlign: TextAlign.start, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                                          ),
                                        ]),
                                      ]),
                                    )),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ]);
                }),
          )),
    );
  }
}
