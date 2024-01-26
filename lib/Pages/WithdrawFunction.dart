import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class WithdrawMoneyPaymentInfoCollection extends StatefulWidget {
  final int balance;
  final String platformName;
  final int star;
  const WithdrawMoneyPaymentInfoCollection({super.key, required this.balance, required this.platformName, required this.star});

  @override
  State<WithdrawMoneyPaymentInfoCollection> createState() => _WithdrawMoneyPaymentInfoCollectionState();
}

class _WithdrawMoneyPaymentInfoCollectionState extends State<WithdrawMoneyPaymentInfoCollection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String platform = 'Bkash';

  @override
  Widget build(BuildContext context) {
    int bal = widget.balance;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.png"), fit: BoxFit.fill)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: const Text("Pay"), backgroundColor: Colors.transparent),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(children: [
                  const Text("Please follow the instruction below:", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.doc('/System Notifications/WithdrawMoneyNotification').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          var data = snapshot.data!.data();
                          return Text(data!['Notify'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Platform: ${widget.platformName}",
                      textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26)),
                  const SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Card(
                          child: TextFormField(
                            controller: _amountController,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                hintText: "Enter Amount",
                                prefixIcon: const Icon(Icons.attach_money_outlined, color: Colors.black)),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Cant be a Empty!';
                              }
                              int amount = int.parse(val);
                              if (amount > widget.balance) {
                                return 'You have insufficient balance!';
                              }
                              return null;
                            },
                            onChanged: (val) {},
                          ),
                        ),
                        /*const SizedBox(height: 10),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(0),
                          child: DropdownButton(
                            items: const [
                              DropdownMenuItem(value: 'Bkash', child: Text('Bkash')),
                              DropdownMenuItem(value: 'Nagad', child: Text('Nagad')),
                              DropdownMenuItem(value: 'Rocket', child: Text('Rocket')),
                            ],
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            onChanged: (String? value) => setState(() => platform = value!),
                            value: platform,
                            isExpanded: true,
                            iconSize: 30,
                            padding: const EdgeInsets.only(left: 15, right: 12, top: 8, bottom: 8),
                            icon: const Icon(Icons.account_balance_wallet),
                            //borderRadius: BorderRadius.circular(20),
                          ),
                        ),*/
                        const SizedBox(height: 10),
                        Card(
                          child: TextFormField(
                            controller: _mobileNumberController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                hintText: "Account Number",
                                prefixIcon: const Icon(Icons.numbers, color: Colors.black)),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Cant be a Empty!';
                              }
                              return null;
                            },
                            onChanged: (val) {},
                          ),
                        ),
                      ])),
                  const SizedBox(height: 20),
                  FloatingActionButton.extended(
                    //child: const Text("Withdraw", style: TextStyle(color: Colors.black, fontSize: 20)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop();

                        int? amount = int.tryParse(_amountController.text)!.abs();
                        String? userEmail = FirebaseAuth.instance.currentUser?.email;

                        if (amount <= widget.star * 1000) {
                          ///

                          FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                                try {
                                  // Create a new document reference
                                  // Set data in the new document
                                  var withdrawRequestDocRef = FirebaseFirestore.instance.collection('Withdraw Request').doc();
                                  transaction.set(withdrawRequestDocRef,
                                      {'Email': userEmail, 'Platform': platform, 'Amount': -amount, 'Mobile Number': _mobileNumberController.text});

                                  // Create a new document reference for the statement
                                  // Set data in the new document
                                  var statementDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                                  transaction.set(statementDocRef, {'amount': -amount, 'type': 'Withdraw Money', 'status': 'Waiting', 'time': DateTime.now()});

                                  // Update the user's coin value
                                  var userDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail);
                                  transaction.update(userDocRef, {'Coin': FieldValue.increment(-amount)});
                                } catch (e) {
                                  showToast('Transaction failed: $e');
                                }
                              })
                              .then((value) => showToast(
                                  'ধন্যবাদ,  আপনার ডিপোজিট বা উইথড্র টি ৪ ঘন্টার মধ্যে সম্পন্ন হবে। দয়া করে অপেক্ষা করুন। যে কোন সমস্যায় হেল্প লাইনে যোগাযোগ করুন'))
                              .catchError((error) => showToast('Error: $error'));
                          //.then((value) => showToast('Transaction Request Success!'))

                          ///
                        } else {
                          showToast('Give amount within your limit.');
                        }
                      }
                    },
                    label: const Text("Withdraw", style: TextStyle(fontSize: 24)),
                  ),
                ]),
              ),
            )),
      ),
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: const Text("Withdraw Money", style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.doc('/System Notifications/WithdrawMoneyNotification').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data!.data();
                  return Text(data!['Notify']);
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Enter Amount",
                    prefixIcon: const Icon(Icons.attach_money_outlined, color: Colors.black)),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Cant be a Empty!';
                  }
                  int amount = int.parse(val);
                  if (amount > widget.balance) {
                    return 'You have insufficient balance!';
                  }
                  return null;
                },
                onChanged: (val) {},
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(0),
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(value: 'Bkash', child: Text('Bkash')),
                    DropdownMenuItem(value: 'Nagad', child: Text('Nagad')),
                    DropdownMenuItem(value: 'Rocket', child: Text('Rocket')),
                  ],
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  onChanged: (String? value) => setState(() => platform = value!),
                  value: platform,
                  isExpanded: true,
                  iconSize: 30,
                  padding: const EdgeInsets.only(left: 15, right: 12, top: 8, bottom: 8),
                  icon: const Icon(Icons.account_balance_wallet),
                  //borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Account Number",
                    prefixIcon: const Icon(Icons.numbers, color: Colors.black)),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Cant be a Empty!';
                  }
                  return null;
                },
                onChanged: (val) {},
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

              int? amount = int.tryParse(_amountController.text)!.abs();
              String? userEmail = FirebaseAuth.instance.currentUser?.email;

              /*
              await FirebaseFirestore.instance.collection('Withdraw Request').doc().set({
                'Email': userEmail,
                'Platform': platform,
                'Amount': -amount,
                'Mobile Number': _mobileNumberController.text,
              }).then((value) {
                FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc().set({
                  'amount': -amount,
                  'type': 'Withdraw Money',
                  'status': 'Waiting',
                  'time': DateTime.now(),
                }).then((value) {
                  FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({'Coin': FieldValue.increment(amount)});
                  showToast('Transaction Request Success!');
                });
              }).onError((error, stackTrace) {
                showToast('Error: $error');
              });
              */

              ///

              FirebaseFirestore.instance
                  .runTransaction((transaction) async {
                    try {
                      // Create a new document reference
                      // Set data in the new document
                      var withdrawRequestDocRef = FirebaseFirestore.instance.collection('Withdraw Request').doc();
                      transaction
                          .set(withdrawRequestDocRef, {'Email': userEmail, 'Platform': platform, 'Amount': -amount, 'Mobile Number': _mobileNumberController.text});

                      // Create a new document reference for the statement
                      // Set data in the new document
                      var statementDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                      transaction.set(statementDocRef, {'amount': -amount, 'type': 'Withdraw Money', 'status': 'Waiting', 'time': DateTime.now()});

                      // Update the user's coin value
                      var userDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail);
                      transaction.update(userDocRef, {'Coin': FieldValue.increment(-amount)});
                    } catch (e) {
                      showToast('Transaction failed: $e');
                    }
                  })
                  .then((value) => showToast('Transaction Request Success!'))
                  .catchError((error) => showToast('Error: $error'));

              ///
            }
          },
          child: const Text("Withdraw", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
