import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class AddMoneyPaymentInfoCollection extends StatefulWidget {
  final String platformName;
  const AddMoneyPaymentInfoCollection({super.key, required this.platformName});

  @override
  State<AddMoneyPaymentInfoCollection> createState() => _AddMoneyPaymentInfoCollectionState();
}

class _AddMoneyPaymentInfoCollectionState extends State<AddMoneyPaymentInfoCollection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  //String platformName = 'Bkash';

  @override
  Widget build(BuildContext context) {
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
                          stream: FirebaseFirestore.instance.doc('/System Notifications/SendMoneyNotification').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            var data = snapshot.data!.data();
                            return Text(data![widget.platformName], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18));
                          }),
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
                          controller: amountController,
                          decoration:
                              InputDecoration(hintText: "Enter Amount", labelText: "Enter Amount", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            int? num = int.tryParse(value!);
                            if (num != null) {
                              return null;
                            } else {
                              return "Insert a number";
                            }
                          },
                        )),
                        const SizedBox(height: 10),
                        Card(
                            child: TextFormField(
                          controller: transactionNumberController,
                          decoration: InputDecoration(
                              hintText: "Enter Transaction ID", labelText: "Enter Transaction ID", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == '') {
                              return "Insert Transaction Number";
                            } else {
                              return null;
                            }
                          },
                        )),
                        const SizedBox(height: 10),
                        Card(
                            child: TextFormField(
                          controller: mobileNumberController,
                          decoration: InputDecoration(
                              hintText: "Enter ${widget.platformName} Mobile Number",
                              labelText: "Enter ${widget.platformName} Mobile Number",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            int? num = int.tryParse(value!);
                            if (num != null) {
                              return null;
                            } else {
                              return "Insert Mobile Number";
                            }
                          },
                        )),
                      ])),
                  const SizedBox(height: 20),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop();

                        int? num = int.tryParse(amountController.text)!.abs();
                        String? userEmail = FirebaseAuth.instance.currentUser?.email;

                        ///

                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                              try {
                                // Create a new document reference for the add money request
                                // Set data in the new document
                                var addMoneyRequestDocRef = FirebaseFirestore.instance.collection('Add Money Request').doc();
                                transaction.set(addMoneyRequestDocRef, {
                                  'Email': userEmail,
                                  'Platform': widget.platformName,
                                  'Amount': num,
                                  'Transaction Number': transactionNumberController.text,
                                  'Mobile Number': mobileNumberController.text,
                                  'Status': 'waiting',
                                });

                                // Create a new document reference for the statement
                                // Set data in the new document
                                var statementDocRef = FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('Statement').doc();
                                transaction.set(statementDocRef, {'amount': num, 'type': 'Add Money', 'status': 'Waiting', 'time': DateTime.now()});
                              } catch (e) {
                                showToast('Transaction failed: $e');
                              }
                            })
                            .then((value) => showToast(
                                'ধন্যবাদ,  আপনার ডিপোজিট বা উইথড্র টি ৪ ঘন্টার মধ্যে সম্পন্ন হবে। দয়া করে অপেক্ষা করুন। যে কোন সমস্যায় হেল্প লাইনে যোগাযোগ করুন'))
                            .catchError((error) => showToast('Error: $error'));
                        //.then((value) => showToast('Transaction Request Success!'))

                        ///
                      }
                    },
                    label: const Text("Add Money", style: TextStyle(fontSize: 24)),
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
