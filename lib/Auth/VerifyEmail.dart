import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';
import 'CreateProfile.dart';

class VerifyEmailWidget extends StatefulWidget {
  const VerifyEmailWidget({super.key});

  @override
  State<VerifyEmailWidget> createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    String? email = user!.email;

    isEmailVerified = user.emailVerified;
    if (!isEmailVerified) {
      try {
        user.sendEmailVerification();
        showToast("A verification mail is sent to $email");
      } catch (e) {
        showToast(e.toString());
      }

      timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        await FirebaseAuth.instance.currentUser!.reload();
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isEmailVerified) timer!.cancel();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user!.email;

    if (isEmailVerified) {
      return const CreateProfileWidget();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("A verification mail is sent to $email", softWrap: true, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 30),
          FloatingActionButton.extended(
            onPressed: () {
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
            label: const Text("Resend verification mail"),
          ),
        ],
      )),
    );
  }
}
