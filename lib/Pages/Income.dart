import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncomeWidget extends StatefulWidget {
  const IncomeWidget({super.key});

  @override
  State<IncomeWidget> createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends State<IncomeWidget> {
  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.png"), fit: BoxFit.fill)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: RichText(
                  softWrap: true,
                  text: const TextSpan(children: <TextSpan>[
                    TextSpan(text: 'Total ', style: TextStyle(fontSize: 24, color: Colors.black)),
                    TextSpan(text: 'Income', style: TextStyle(fontSize: 24, color: Color(0xFF016DF7))),
                  ]))),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.doc('user_list/$userEmail').snapshots(),
                builder: (context, snapshot) {
                  var data = snapshot.data!.data();
                  //List child = data!['Child List'];
                  List count = data!['Count'];
                  int income = data['Income'];
                  /*if (child.isEmpty) {
                    //return const Center(child: Text('No Data'));
                    child = List.filled(10, 0);
                    count = List.filled(10, 0);
                    income = 0;
                  }*/
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                          alignment: FractionalOffset.centerRight,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: InteractiveViewer(
                                        panEnabled: false, // Set it to false
                                        boundaryMargin: const EdgeInsets.all(10),
                                        minScale: 0.5,
                                        maxScale: 2,
                                        child: Image.asset("Assets/EarningList.jpeg", fit: BoxFit.fitWidth),
                                      ),
                                    );
                                  },
                                );
                                //showAboutDialog(context: context, children: [Image.asset("Assets/EarningList.jpeg")]);
                                //Dialog(child: Image.asset("Assets/EarningList.jpeg"));
                                //AlertDialog(content: Image.asset("Assets/EarningList.jpeg"));
                              },
                              child: const Text("You can earn"))),
                      Center(
                          child: Text("Your total income is: \n$income",
                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: count.length,
                            itemBuilder: (context, index) {
                              //int amount = index + 1;
                              int counts = count[index];
                              int taka = (index + 1) * 10;
                              if (index == 0) {
                                taka = 50;
                              } else if (index == 1)
                                taka = 100;
                              else if (index == 2)
                                taka = 120;
                              else if (index == 3)
                                taka = 120;
                              else if (index == 4) taka = 100;

                              income = counts * taka;
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(children: [
                                  Card(
                                      color: Colors.amberAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text('Level ${index + 1}:'),
                                      )),
                                  const Text(' => '),
                                  Card(
                                      color: Colors.yellowAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text('$counts x $taka'),
                                      )),
                                  const Text(' = '),
                                  Card(
                                      color: Colors.yellowAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text('${counts * taka}'),
                                      )),
                                ]),
                              ));
                            }),
                      ),
                    ],
                  );
                }),
          )),
    );
  }
}
