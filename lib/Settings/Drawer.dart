import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All%20Functions%20Page/Functions.dart';
import '../Auth/AuthTree.dart';
import '../Pages/Income.dart';
import '../Pages/Member.dart';
import '../Pages/Statement.dart';
import '../Pages/Profile.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16,
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 1, 0),
            child: Container(
                width: 270,
                height: double.infinity,
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0xFFE5E7EB), offset: Offset(1, 0))]),
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      /// Logo + name
                      const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Row(children: [
                            //Icons.add_task_rounded,
                            Icon(Icons.videogame_asset_outlined, color: Color(0xFF6F61EF), size: 32),
                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Text('Game Hub', style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF15161E), fontSize: 24, fontWeight: FontWeight.w500)))
                          ])),

                      /// Search Button
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Icon(Icons.search_rounded, color: Color(0xFF606A85), size: 28),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                        child: Text('Search', style: TextStyle(color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                  ])))),

                      /// Dashboard
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Icon(Icons.dashboard_rounded, color: Color(0xFF6F61EF), size: 28),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                        child: Text('Dashboard', style: TextStyle(color: Color(0xFF15161E), fontSize: 16, fontWeight: FontWeight.w500)))
                                  ])))),

                      /// Members
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () => nextPage(OneLevelMember(email: '$userEmail'), context),
                                  child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Icon(Icons.groups, color: Color(0xFF606A85), size: 28),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Text('Members', style: TextStyle(color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                      ]))))),

                      /// Statements
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () => nextPage(const StatementsWidget(), context),
                                  child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Icon(Icons.document_scanner_rounded, color: Color(0xFF606A85), size: 28),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Text('Statements', style: TextStyle(color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                      ]))))),

                      /// Total Income
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () => nextPage(const IncomeWidget(), context),
                                  child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Icon(Icons.monetization_on_outlined, color: Color(0xFF606A85), size: 28),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Text('Total Income', style: TextStyle(color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                      ]))))),

                      /// Profile
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () => nextPage(const ProfileWidget(), context),
                                  child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Icon(Icons.account_circle_rounded, color: Color(0xFF606A85), size: 28),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Text('Profile',
                                                style: TextStyle(fontFamily: 'Plus Jakarta Sans', color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                      ]))))),

                      /// Logout
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () {
                                    FirebaseAuth.instance.signOut();
                                    newPage(const AuthTreeWidget(), context);
                                  },
                                  child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Icon(Icons.logout, color: Color(0xFF606A85), size: 28),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Text('Log Out', style: TextStyle(color: Color(0xFF606A85), fontSize: 16, fontWeight: FontWeight.w500)))
                                      ]))))),

                      /// Trailer Profile
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                const Divider(height: 12, thickness: 2, color: Color(0xFFE5E7EB)),
                                Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                                      Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: const Color(0x4D9489F5),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFF6F61EF), width: 2)),
                                          child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                      fadeInDuration: const Duration(milliseconds: 500),
                                                      fadeOutDuration: const Duration(milliseconds: 500),
                                                      imageUrl:
                                                          'https://images.unsplash.com/photo-1624561172888-ac93c696e10c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjJ8fHVzZXJzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                                                      width: 44,
                                                      height: 44,
                                                      fit: BoxFit.cover)))),
                                      const Expanded(
                                          child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Text('BDGameHubs', style: TextStyle(color: Color(0xFF15161E), fontSize: 16, fontWeight: FontWeight.w500)),
                                                Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                    child: Text('bdgamehubs@gmail.com',
                                                        style: TextStyle(color: Color(0xFF606A85), fontSize: 14, fontWeight: FontWeight.w500))),
                                                /*Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                        child: Text('View Profile',
                                                            style: TextStyle(
                                                                fontFamily: 'Plus Jakarta Sans',
                                                                color: Color(0xFF6F61EF),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500)))*/
                                              ])))
                                    ]))
                              ])))
                    ])))));
  }
}
