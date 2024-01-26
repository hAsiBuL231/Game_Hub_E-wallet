import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Auth/VerifyEmail.dart';
import '../All Functions Page/Functions.dart';
import 'Login.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController referralTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  bool passwordVisibility1 = false;
  bool passwordVisibility2 = false;
  bool isLoading = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42BEA5),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 200,
            decoration: BoxDecoration(color: const Color(0xFF42BEA5), image: DecorationImage(fit: BoxFit.cover, image: Image.asset('Assets/black1.png').image)),
            child: const Image(image: AssetImage('Assets/image1.png')),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                /// Name
                /*
                    Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: TextFormField(
                            controller: fullNameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter your name here...',
                              floatingLabelStyle: const TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                              errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: const Color(0xFF359F8A),
                            ),
                            style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.outfit().fontFamily),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == '') {
                                return "Insert your name";
                              } else {
                                return null;
                              }
                            })),
                    */

                /// Email
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextFormField(
                        controller: emailTextController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter a email',
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: const Color(0xFF359F8A),
                        ),
                        style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.outfit().fontFamily),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          //int? num = int.tryParse(value!);
                          //if (num != null && value.length == 10) {
                          if (value!.isEmpty) {
                            return "Please enter a email";
                          }
                          return null;
                          //return 'Please enter a 10 digit number!';
                        })),

                /// User ID
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: userIDController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        hintText: 'Enter a 10 digit number',
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                        focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE21C3D), width: 1), borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: const Color(0xFF359F8A),
                      ),
                      style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.outfit().fontFamily),
                      validator: (value) {
                        int? num = int.tryParse(value!);
                        if (num != null && num.toString().length == 10) {
                          return null;
                        } else {
                          return 'Please enter a 10 digit number with no leading 0!';
                        }
                      },
                    )),

                /// Password
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextFormField(
                        controller: passwordTextController,
                        obscureText: !passwordVisibility1,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter a password here...',
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: const Color(0xFF359F8A),
                          suffixIcon: InkWell(
                              onTap: () => setState(() => passwordVisibility1 = !passwordVisibility1),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(passwordVisibility1 ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0x80FFFFFF), size: 22)),
                        ),
                        style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.outfit().fontFamily),
                        validator: (input) {
                          if (input!.length < 6) {
                            return 'Your password needs to be at least 6 character';
                          }
                          return null;
                        })),

                /// Confirm Password
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: TextFormField(
                    controller: confirmPasswordTextController,
                    obscureText: !passwordVisibility2,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm password here...',
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: const Color(0xFF359F8A),
                      suffixIcon: InkWell(
                          onTap: () => setState(() => passwordVisibility2 = !passwordVisibility2),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            passwordVisibility2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0x80FFFFFF),
                            size: 22,
                          )),
                    ),
                    style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.outfit().fontFamily),
                    validator: (input) {
                      if (input != passwordTextController.text) {
                        return 'Your password needs to be matched previous one!';
                      }
                      return null;
                    },
                  ),
                ),
              ]),
            ),
          ),
//////////////////////////////////////////////////////////////////// Register Button //////////////////////////////////////////////////////////////////
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (!isLoading)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    String email = emailTextController.text.trim();
                    String password = passwordTextController.text.trim();
                    int id = int.parse(userIDController.text.trim());

                    var querySnapshot = await FirebaseFirestore.instance.collection('UserID').where('ID', isEqualTo: id).get();
                    if (querySnapshot.docs.isNotEmpty) {
                      showToast("The user id is taken, Try another one!");
                    } else {
                      // No user found with the given number
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                      } catch (e) {
                        showToast(e.toString());
                      }
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance.collection('UserID').doc(email).set({"ID": id});
                        nextPage(const VerifyEmailWidget(), context);

                        /*user.sendEmailVerification();

                        showToast("A verification mail is sent to $email");

                        timer = Timer.periodic(const Duration(seconds: 10), (_) async {
                          user.reload();
                          if (user.emailVerified) {
                            await FirebaseFirestore.instance.collection('UserID').doc(email).set({"ID": id});
                            newPage(const CreateProfileWidget(), context);
                            timer?.cancel();
                            // hossainhasibul2@gmail.com
                          }
                          //nextPage(const AuthTreeWidget(), context);
                          /*StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (user.emailVerified) {
                                  FirebaseFirestore.instance.collection('UserID').doc(email).set({"ID": id});
                                  return authentication(context);
                                }
                              }
                              return const AuthTreeWidget();
                            },
                          );*/
                        });
                        */
                      }
                    }
                    setState(() => isLoading = false);
                  }
                },
                label: Text("Create Account", style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: Colors.white)),
                isExtended: true,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 3,
                backgroundColor: Colors.black,
                extendedPadding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 60),
              ),
            ),
////////////////////////////////////////////////////////////// Already have an account? ////////////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text('Already have an account? ', style: TextStyle(color: Colors.black)),
                TextButton(
                    onPressed: () => nextPage(const LoginWidget(), context),
                    child: Text('Login', style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: Colors.white))),
              ]),
              const SizedBox(height: 50)
            ]),
          ),
        ]),
      ),
    );
  }
}
