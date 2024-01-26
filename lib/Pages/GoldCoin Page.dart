import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class GoldCoinPage extends StatefulWidget {
  const GoldCoinPage({super.key, required this.star});
  final int star;

  @override
  State<GoldCoinPage> createState() => _GoldCoinPageState();
}

class _GoldCoinPageState extends State<GoldCoinPage> {
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
                    TextSpan(text: 'Gold ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: 'Coin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF016DF7))),
                  ]))),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.doc('Gold_Coin/$userEmail').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.data!.exists) {
                  FirebaseFirestore.instance.doc('Gold_Coin/$userEmail').set({"coin": 0, "count": 0, "timestamp": Timestamp.fromDate(DateTime(2024, 01, 06, 12, 0, 0))});
                }

                ///
                var data = snapshot.data!.data();
                int coin = data!['coin'];
                return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Center(
                      child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Your total coin is: \n$coin",
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black))),
                  )),
                  const SizedBox(height: 50),

                  /// ////////////////////////////////////////////////  Transfer Coin   ////////////////////////////////////////
                  ElevatedButton(
                      onPressed: () {
                        if (widget.star < 3) {
                          showToast("Needs minimum 3 star to enable this function");
                        } else {
                          int amount = 0;
                          final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                          final TextEditingController amountController = TextEditingController();
                          final TextEditingController receiversIDController = TextEditingController();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                    title: const Text("Transfer Coin", style: TextStyle(color: Colors.black)),
                                    content: SingleChildScrollView(
                                      child: Form(
                                          key: formKey,
                                          child: Column(children: [
                                            TextFormField(
                                                controller: amountController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                    hintText: "Enter Amount",
                                                    prefixIcon: const Icon(Icons.currency_bitcoin, color: Colors.black)),
                                                validator: (val) {
                                                  amount = int.parse(val!).abs();
                                                  if (val.isEmpty) {
                                                    return 'Cant be a Empty!';
                                                  } else if (amount > coin) return 'You have insufficient coin!';
                                                  return null;
                                                }),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                                controller: receiversIDController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                    hintText: "Receivers ID",
                                                    prefixIcon: const Icon(Icons.supervisor_account, color: Colors.black)),
                                                validator: (val) {
                                                  if (val!.isEmpty) return 'Cant be a Empty!';
                                                  return null;
                                                }),
                                          ])),
                                    ),
                                    actions: [
                                      ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel", style: TextStyle(color: Colors.black))),
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (formKey.currentState!.validate()) {
                                              Navigator.of(context).pop();

                                              String receiver = receiversIDController.text.trim();

                                              int? receiverID = int.tryParse(receiver);
                                              if (receiverID != null) {
                                                await FirebaseFirestore.instance.collection('UserID').where("ID", isEqualTo: receiverID).get().then((value) {
                                                  var id = value.docs.first.id;
                                                  receiver = id;
                                                });

                                                var snap = await FirebaseFirestore.instance.collection('user_list').doc(receiver).get();

                                                if (snap.exists) {
                                                  FirebaseFirestore.instance
                                                      .runTransaction((transaction) async {
                                                        try {
                                                          // Update the receiver's coin value
                                                          var receiverDocRef = FirebaseFirestore.instance.collection('Gold_Coin').doc(receiver);
                                                          transaction.update(receiverDocRef, {'coin': FieldValue.increment(amount)});

                                                          // Update the sender's coin value
                                                          var senderDocRef = FirebaseFirestore.instance.collection('Gold_Coin').doc(userEmail);
                                                          transaction.update(senderDocRef, {'coin': FieldValue.increment(-amount)});
                                                        } catch (e) {
                                                          showToast('Transaction failed: $e');
                                                        }
                                                      })
                                                      .then((value) => showToast('Transaction Success!'))
                                                      .catchError((error) => showToast('Error: $error'));
                                                } else {
                                                  showToast("The user $receiver doesn't exists!");
                                                }
                                              }
                                            }
                                          },
                                          child: const Text("Transfer", style: TextStyle(color: Colors.black)))
                                    ]);
                              });
                        }
                      },
                      child: const Text("Transfer Coin", style: TextStyle(fontSize: 20))),
                  const SizedBox(height: 10),

                  /// ////////////////////////////////////////////////  Convert Coin   ////////////////////////////////////////

                  ElevatedButton(
                      onPressed: () {
                        nextPage(ConvertCoin(coin: coin), context);
                        /*final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            builder: (context) {
                              int amount = 1000000;
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  title: const Text("Convert Coin", style: TextStyle(color: Colors.black)),
                                  content: SingleChildScrollView(
                                    child: Form(
                                        key: _formKey,
                                        child: Column(children: [
                                          Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(10)),
                                              margin: const EdgeInsets.all(0),
                                              child: DropdownButton(
                                                items: const [
                                                  DropdownMenuItem(value: 1000000, child: Text('1 Million')),
                                                  DropdownMenuItem(value: 2000000, child: Text('2 Million')),
                                                  DropdownMenuItem(value: 3000000, child: Text('3 Million')),
                                                  DropdownMenuItem(value: 4000000, child: Text('4 Million')),
                                                  DropdownMenuItem(value: 5000000, child: Text('5 Million')),
                                                ],
                                                style: const TextStyle(fontSize: 18, color: Colors.black),
                                                onChanged: (value) => amount = value!,
                                                value: amount,
                                                isExpanded: true,
                                                iconSize: 30,
                                                padding: const EdgeInsets.only(left: 15, right: 12, top: 8, bottom: 8),
                                                icon: const Icon(Icons.account_balance_wallet),
                                              )),
                                        ])),
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel", style: TextStyle(color: Colors.black))),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            Navigator.of(context).pop();
                                            FirebaseFirestore.instance
                                                .runTransaction((transaction) async {
                                                  try {
                                                    // Update the coin value
                                                    var senderDocRef = FirebaseFirestore.instance.collection('Gold_Coin').doc(userEmail);
                                                    transaction.update(senderDocRef, {'coin': FieldValue.increment(-amount)});

                                                    // Create a new document reference for the sender's statement
                                                    var senderStatementDocRef =
                                                        FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                                                    transaction
                                                        .set(senderStatementDocRef, {'amount': amount, 'type': 'Coin Conversion', 'status': "", 'time': DateTime.now()});
                                                    transaction.update(senderStatementDocRef, {});
                                                  } catch (e) {
                                                    showToast('Transaction failed: $e');
                                                  }
                                                })
                                                .then((value) => showToast('Transaction Success!'))
                                                .catchError((error) => showToast('Error: $error'));
                                          }
                                        },
                                        child: const Text("Convert", style: TextStyle(color: Colors.black)))
                                  ]);
                            });*/
                      },
                      child: const Text("Convert Coin (to Taka)", style: TextStyle(fontSize: 20))),
                  const SizedBox(height: 20),
                  //Text("1 Million Coin = 100 taka \n (You can exchange coin as per millon)"),
                  const Center(
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("1 মিলিয়ন কয়েন = 100 টাকা \n(প্রতি মিলিয়ন হিসাবে কয়েন রূপান্তর করতে হবে)",
                                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))))
                ]);
              })),
    );
  }
}

class ConvertCoin extends StatefulWidget {
  const ConvertCoin({super.key, required this.coin});
  final int coin;

  @override
  State<ConvertCoin> createState() => _ConvertCoinState();
}

class _ConvertCoinState extends State<ConvertCoin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int amount = 1;
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text("Convert Coin", style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: [
                Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(0),
                    child: DropdownButton(
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 Million')),
                        DropdownMenuItem(value: 2, child: Text('2 Million')),
                        DropdownMenuItem(value: 3, child: Text('3 Million')),
                        DropdownMenuItem(value: 4, child: Text('4 Million')),
                        DropdownMenuItem(value: 5, child: Text('5 Million')),
                      ],
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      onChanged: (value) => setState(() => amount = value!),
                      value: amount,
                      isExpanded: true,
                      iconSize: 30,
                      padding: const EdgeInsets.only(left: 15, right: 12, top: 8, bottom: 8),
                      icon: const Icon(Icons.currency_bitcoin),
                    )),
              ])),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel", style: TextStyle(color: Colors.black))),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  if (widget.coin < (amount * 1000000)) {
                    showToast("You have insufficient coin!");
                  } else {
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                          try {
                            // Update the coin value
                            var senderDocRef = FirebaseFirestore.instance.collection('Gold_Coin').doc(userEmail);
                            transaction.update(senderDocRef, {'coin': FieldValue.increment(-amount * 1000000)});

                            // Create a new document reference for the sender's statement
                            var statementDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                            transaction.set(statementDocRef, {'amount': (amount * 100), 'type': 'Coin Conversion', 'status': "", 'time': DateTime.now()});

                            var userDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail);
                            transaction.update(userDocRef, {"Coin": FieldValue.increment(amount * 100)});
                          } catch (e) {
                            showToast('Transaction failed: $e');
                          }
                        })
                        .then((value) => showToast('Transaction Success!'))
                        .catchError((error) => showToast('Error: $error'));
                  }
                }
              },
              child: const Text("Convert", style: TextStyle(color: Colors.black)))
        ]);
  }
}
