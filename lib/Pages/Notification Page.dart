import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: RichText(
              softWrap: true,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(text: 'Notifications ', style: TextStyle(fontSize: 24, color: Colors.black)),
                TextSpan(text: 'Page', style: TextStyle(fontSize: 24, color: Color(0xFF016DF7))),
              ]))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Notifications').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('No Notifications'));
              }
              var documents = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var data = documents.elementAt(index);
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data['Notify']),
                  ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
