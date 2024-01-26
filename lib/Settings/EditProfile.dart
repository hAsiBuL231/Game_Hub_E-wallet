import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All%20Functions%20Page/Functions.dart';
import '../HomePage.dart';
import '../Settings/GetImage.dart';


class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //TextEditingController emailController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController(text: "");
    phoneController = TextEditingController(text: "");
    //emailController = TextEditingController(text: "");

    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    String? userImage = FirebaseAuth.instance.currentUser?.photoURL;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        /*automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: ()=>Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 32,
            ),
          ),*/
        title: const Text('Edit Profile'),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CircleAvatar(backgroundColor: Colors.deepPurpleAccent, child: CachedNetworkImage(imageUrl: '$userImage', fit: BoxFit.cover)),
                  )),
              const SizedBox(height: 20),
              FloatingActionButton.extended(onPressed: () => nextPage(const GetImage(), context), label: const Text("Change Photo"), heroTag: 'tag1'),
              Form(
                  key: _formKey,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('user_list').doc(userEmail).snapshots(),
                      builder: (context, snapshot) {
                        var data = snapshot.data!.data();
                        nameController = TextEditingController(text: data!['User Name']);
                        phoneController = TextEditingController(text: "${data['Phone']}");
                        //emailController = TextEditingController(text: data['Email']);
                        List list = data["Parent List"];
                        int referral = list.length;

                        return Column(children: [
                          /// Name
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                            child: TextFormField(
                              controller: nameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Your Name',
                                hintText: 'Enter your name...',
                                enabledBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                focusedBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                focusedErrorBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return "Insert your name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          /// Phone
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                            child: TextFormField(
                              controller: phoneController,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'Enter your phone number...',
                                enabledBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                focusedBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                focusedErrorBorder:
                                    OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                int? num = int.tryParse(value!);
                                if (num != null && value.length == 11) {
                                  return null;
                                }
                                return 'Please enter 11 digit number!';
                              },
                            ),
                          ),

                          /// Referral ID
                          if (referral == 0)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: referralController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Referral ID',
                                  hintText: 'Enter your referral id..',
                                  enabledBorder:
                                      OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                  errorBorder:
                                      OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                  focusedErrorBorder:
                                      OutlineInputBorder(borderSide: const BorderSide(color: Color(0x00000000), width: 1), borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                        ]);
                      })),
              const SizedBox(height: 30),
              if (isLoading) const Center(child: CircularProgressIndicator()),
              if (!isLoading)
                FloatingActionButton.extended(
                    onPressed: () async {
                      //if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      String name = nameController.text.trim();
                      String referral = referralController.text.trim();
                      int phone = int.parse(phoneController.text.trim());
                      //String email = emailController.text.trim();

                      if (name != '') {
                        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
                        await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({
                          'User Name': userName,
                        }).onError((error, stackTrace) {
                          showToast(error.toString());
                        });
                      }
                      if (phone != 0) {
                        await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({
                          'Phone': phone,
                        }).onError((error, stackTrace) {
                          showToast(error.toString());
                        });
                      }
                      /*if (email != '') {
                        await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({
                          'Email': email,
                        }).onError((error, stackTrace) {
                          showToast(error.toString());
                        });
                      }*/
                      if (referral != '') {
                        /// Convert
                        int? num = int.tryParse(referral);
                        if (num != null) {
                          await FirebaseFirestore.instance.collection('UserID').where("ID", isEqualTo: num).get().then((value) {
                            if (value.docs.isEmpty) {
                              showToast("Referral ID is incorrect!");
                            } else {
                              referral = value.docs.first.id;
                              FirebaseFirestore.instance.collection('user_list').doc(referral).update({'Notice': userEmail});
                              showToast("A request is sent to the user.");
                            }
                          });
                        } else {
                          showToast("Referral ID is incorrect!");
                        }
                      }

                      setState(() => isLoading = false);
                      newPage(const HomepageWidget(), context);
                      //}
                    },
                    elevation: 3,
                    label: const Text("Save Changes")),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ),
    );
  }
}
