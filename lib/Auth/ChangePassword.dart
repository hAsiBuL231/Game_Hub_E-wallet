import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  Color primaryBackground = Colors.black26;
  Color secondaryBackground = Colors.white;
  Color primaryText = Colors.black;
  Color secondaryText = Colors.blueAccent;

  TextEditingController emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Change Password'), centerTitle: false, elevation: 0),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: secondaryBackground,
                boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x230E151B), offset: Offset(0, 2))],
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16), topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                      child: Text('Enter your email or the 10 digit code and we will send a reset password link to your email for you to update it.', softWrap: true)),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: emailTextController,
                        obscureText: false,
                        decoration: InputDecoration(
                            labelText: 'Email/ID here...',
                            hintText: 'We will send a link to your email...',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryBackground, width: 1), borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                            errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                            focusedErrorBorder:
                                OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: primaryBackground,
                            prefixIcon: Icon(Icons.email_outlined, color: secondaryText)),
                        keyboardType: TextInputType.emailAddress,
                      )),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 26),
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            String email = emailTextController.text.trim();

                            if (emailTextController.text.isEmpty) {
                              //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email required!')));
                              showToast("Valid Email or 10 digit ID is required!");
                            } else {
                              int? num = int.tryParse(email);
                              if (num != null) {
                                await FirebaseFirestore.instance.collection('UserID').where("ID", isEqualTo: num).get().then((value) {
                                  var id = value.docs.first.id;
                                  email = id;
                                  //showToast(id);
                                });
                                //FirebaseFirestore.instance.collection('UserID').doc('$num').get().then((value) => value.id);
                              }
                              try {
                                FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                showToast("A mail is sent to your email.");
                              } catch (e) {
                                showToast(e.toString());
                              }
                              //snackBar("A mail is sent to your email.", context);
                            }
                          },
                          label: const Text('Send Link'),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
