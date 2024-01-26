import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../All Functions Page/FirebaseFunction.dart';
import '../All Functions Page/Functions.dart';
import 'ChangePassword.dart';
import 'Register.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool passwordVisibility = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42BEA5),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
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
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: emailTextController,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: 'Email/ID',
                          hintText: 'Enter email or 10 digit ID...',
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          hintStyle: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, color: Colors.black54),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: const Color(0xFF359F8A),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF42BEA5))),
                      style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, color: const Color(0x9AFFFFFF)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        /*int? num = int.tryParse(value!);
                        if (num != null && value.length == 10) {
                          return null;
                        }
                        return 'Please enter your 10 digit ID!';*/
                        if (value!.isEmpty) {
                          return "Please enter a email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: passwordTextController,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password here...',
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          hintStyle: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, color: Colors.black54),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF359F8A), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: const Color(0xFF359F8A),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF42BEA5)),
                          suffixIcon: InkWell(
                              onTap: () => setState(() => passwordVisibility = !passwordVisibility),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0x80FFFFFF), size: 22))),
                      style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, color: const Color(0x9AFFFFFF)),
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Your password needs to be at least 6 character';
                        }
                        return null;
                      },
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => nextPage(const ChangePasswordWidget(), context),
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                        textStyle: MaterialStatePropertyAll(TextStyle(decoration: TextDecoration.underline))),
                    child: const Text("Forgot Password?", style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'OpenSans')))
              ]),
            ),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      String email = emailTextController.text.trim();
                      String password = passwordTextController.text.trim();

                      /// Convert
                      int? num = int.tryParse(email);
                      if (num != null) {
                        await FirebaseFirestore.instance.collection('UserID').where("ID", isEqualTo: num).get().then((value) {
                          var id = value.docs.first.id;
                          email = id;
                        });
                      }

                      /// FirebaseFirestore.instance.collection('UserID').doc('$num').get().then((value) => value.id);
                      ///
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                      } catch (e) {
                        showToast(e.toString());
                        setState(() => isLoading = false);
                        return;
                      }
                      authentication(context);
                      setState(() => isLoading = false);
                    }
                  },
                  label: Text("Login", style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: Colors.white)),
                  isExtended: true,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 3,
                  backgroundColor: Colors.black,
                  extendedPadding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 60),
                ),
              ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 44, 0, 30),
              child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text('Don’t have an account yet? ', style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, color: Colors.black)),
                TextButton(
                    onPressed: () => nextPage(const RegisterWidget(), context),
                    child: Text('Register', style: TextStyle(fontFamily: GoogleFonts.outfit().fontFamily, fontWeight: FontWeight.bold, color: Colors.white))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
