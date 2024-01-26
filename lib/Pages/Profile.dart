import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Auth/AuthTree.dart';
import '../Settings/EditProfile.dart';
import '../All Functions Page/Functions.dart';
import '../Auth/ChangePassword.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> with TickerProviderStateMixin {
  /*
  //late Profile6Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'buttonOnPageLoadAnimation': Animate(
      //trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 400.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: const Offset(0, 60),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Profile6Model());

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
*/

  Color primary = Colors.lightBlueAccent;
  Color secondary = Colors.blueAccent;
  Color black = Colors.black;
  Color white = Colors.white;
  Color back = Colors.black;
  Color front = Colors.black;

  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String? userName = FirebaseAuth.instance.currentUser?.displayName;
  String? userImage = FirebaseAuth.instance.currentUser?.photoURL;

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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  child: Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(color: primary, image: const DecorationImage(fit: BoxFit.cover, image: AssetImage("Assets/background_hill.webp"))),
                    ),
                    Align(
                        alignment: const AlignmentDirectional(-1, 1),
                        child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
                            child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(color: primary, shape: BoxShape.circle, border: Border.all(color: secondary, width: 2)),
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.deepPurpleAccent,
                                          child: CachedNetworkImage(
                                              fadeInDuration: const Duration(milliseconds: 500),
                                              fadeOutDuration: const Duration(milliseconds: 500),
                                              imageUrl: '$userImage',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover),
                                        ))))))
                  ])),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                child: Text(userName!, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 2),
                child: Text(
                  "Email: $userEmail",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                child: Text(
                  "ID: $uniqueID",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  'Your Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily),
                ),
              ),
              GestureDetector(
                onTap: () => nextPage(const EditProfileWidget(), context),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000), offset: Offset(0, 1))],
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        const Icon(Icons.account_circle_outlined, color: Colors.black, size: 24),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text('Edit Profile', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily)),
                        ),
                        const Expanded(
                          child: Align(alignment: AlignmentDirectional(0.9, 0), child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18)),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => nextPage(const ChangePasswordWidget(), context),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000), offset: Offset(0, 1))],
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        const Icon(Icons.change_circle_outlined, color: Colors.black, size: 24),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text('Change Password', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily)),
                        ),
                        const Expanded(
                          child: Align(alignment: AlignmentDirectional(0.9, 0), child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18)),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000), offset: Offset(0, 1))],
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Icon(Icons.notifications_none, color: black, size: 24),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Text('Notification Settings', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily)),
                      ),
                      Expanded(
                        child: Align(alignment: const AlignmentDirectional(0.9, 0), child: Icon(Icons.arrow_forward_ios, color: black, size: 18)),
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                child: Text('App Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily)),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: white,
                          boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000), offset: Offset(0, 1))],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.help_outline_rounded, color: black, size: 24),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text('Support', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily))),
                          Expanded(child: Align(alignment: const AlignmentDirectional(0.9, 0), child: Icon(Icons.arrow_forward_ios, color: black, size: 18))),
                        ]),
                      ))),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: white,
                          boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000), offset: Offset(0, 1))],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.privacy_tip_rounded, color: black, size: 24),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text('Terms of Service', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.outfit().fontFamily))),
                          Expanded(child: Align(alignment: const AlignmentDirectional(0.9, 0), child: Icon(Icons.arrow_forward_ios, color: black, size: 18))),
                        ]),
                      ))),
              const SizedBox(height: 20),
              Center(
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        newPage(const AuthTreeWidget(), context);
                      },
                      label: const Text("  Log Out  "),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black)),
              const SizedBox(height: 30),
              /*Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();

                      context.goNamedAuth('null', context.mounted);
                    },
                    text: 'Log Out',
                    options: FFButtonOptions(
                      width: 150,
                      height: 44,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
                      elevation: 0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).lineColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ).animateOnPageLoad(animationsMap['buttonOnPageLoadAnimation']!),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
