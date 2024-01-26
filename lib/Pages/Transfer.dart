import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class TransferWidget extends StatefulWidget {
  const TransferWidget({super.key, required this.balance, required this.star});
  final int balance;
  final int star;

  @override
  State<TransferWidget> createState() => _TransferWidgetState();
}

class _TransferWidgetState extends State<TransferWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _receiversIDController = TextEditingController();

  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  int uniqueID = 0;

  getID() async {
    await FirebaseFirestore.instance.collection('UserID').doc(userEmail).get().then((value) {
      var data = value.data();
      setState(() {
        uniqueID = data!["ID"];
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
    int amount = 0;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text("Transfer Money", style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Enter Amount",
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.black)),
                  validator: (val) {
                    amount = int.parse(val!).abs();
                    if (val.isEmpty) {
                      return 'Cant be a Empty!';
                    } else if (amount > widget.balance) {
                      return 'You have insufficient balance!';
                    } else if (amount > widget.star * 1000) {
                      return 'Your limit is maximum ${widget.star * 1000}';
                    }
                    return null;
                  },
                  //onChanged: (val) {},
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _receiversIDController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Receivers ID",
                      prefixIcon: const Icon(Icons.supervisor_account, color: Colors.black)),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Cant be a Empty!';
                    }
                    return null;
                  },
                  //onChanged: (val) {},
                ),
              ])),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();

                String receiver = _receiversIDController.text.trim();

                int? num = int.tryParse(receiver);
                if (num != null) {
                  await FirebaseFirestore.instance.collection('UserID').where("ID", isEqualTo: num).get().then((value) {
                    var id = value.docs.first.id;
                    receiver = id;
                  });

                  var snap = await FirebaseFirestore.instance.collection('user_list').doc(receiver).get();

                  if (snap.exists) {
                    /*
                    await FirebaseFirestore.instance.collection('user_list').doc(receiver).update({
                      'Coin': FieldValue.increment(amount),
                    });
                    await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({
                      'Coin': FieldValue.increment(-amount),
                    });
                    showToast('Transaction Request Success!');

                    FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc().set({
                      'amount': -amount,
                      'type': 'Balance Transfer',
                      'status': "Sent to: $num",
                      'time': DateTime.now(),
                    });
                    FirebaseFirestore.instance.collection('user_list').doc(receiver).collection('Statement').doc().set({
                      'amount': amount,
                      'type': 'Balance Transfer',
                      'status': 'From: $uniqueID',
                      'time': DateTime.now(),
                    });
                    */

                    ///

                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                          try {
                            // Update the receiver's coin value
                            var receiverDocRef = FirebaseFirestore.instance.collection('user_list').doc(receiver);
                            transaction.update(receiverDocRef, {'Coin': FieldValue.increment(amount)});

                            // Update the sender's coin value
                            var senderDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail);
                            transaction.update(senderDocRef, {'Coin': FieldValue.increment(-amount)});

                            // Create a new document reference for the sender's statement
                            // Set data in the new document
                            var senderStatementDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                            transaction.set(senderStatementDocRef, {'amount': -amount, 'type': 'Balance Transfer', 'status': "Sent to: $num", 'time': DateTime.now()});

                            // Create a new document reference for the receiver's statement
                            // Set data in the new document
                            var receiverStatementDocRef = FirebaseFirestore.instance.collection('user_list').doc(receiver).collection('Statement').doc();
                            transaction.set(receiverStatementDocRef, {'amount': amount, 'type': 'Balance Transfer', 'status': 'From: $uniqueID', 'time': DateTime.now()});
                          } catch (e) {
                            showToast('Transaction failed: $e');
                          }
                        })
                        .then((value) => showToast('Transaction Success!'))
                        .catchError((error) => showToast('Error: $error'));

                    ///
                  } else {
                    showToast("The user $receiver doesn't exists!");
                  }
                }
              }
            },
            child: const Text("Transfer", style: TextStyle(color: Colors.black)),
          ),
        ]);
  }
}
