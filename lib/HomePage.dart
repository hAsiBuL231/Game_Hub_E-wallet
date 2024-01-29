import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamehub2/Admob/adpage.dart';

import 'All Functions Page/FirebaseFunction.dart';
import 'All Functions Page/Functions.dart';
import 'Pages/A Payment Gateway.dart';
import 'Pages/Games.dart';
import 'Pages/GoldCoin Page.dart';
import 'Pages/Income.dart';
import 'Pages/Member.dart';
import 'Pages/Notification Page.dart';
import 'Pages/Transfer.dart';
import 'Settings/Drawer.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({super.key});

  @override
  _HomepageWidgetState createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String? userName = FirebaseAuth.instance.currentUser?.displayName;
  //String? userImage = FirebaseAuth.instance.currentUser?.photoURL;
  bool _isAnimated = false;
  bool _isBalanceShown = false;
  bool _isBalance = true;
  void balanceShowChangeState() async {
    _isAnimated = true;
    _isBalance = false;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 800), () => setState(() => _isBalanceShown = true));
    await Future.delayed(const Duration(seconds: 3), () => setState(() => _isBalanceShown = false));
    await Future.delayed(const Duration(milliseconds: 200), () => setState(() => _isAnimated = false));
    await Future.delayed(const Duration(milliseconds: 800), () => setState(() => _isBalance = true));
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: "Game Hub Beta",
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.png"), fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            drawer: const DrawerWidget(),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                    snap: false,
                    pinned: true,
                    floating: false,
                    title: const Text('Game Hub', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
                    actions: [
                      InkWell(
                          onTap: () => nextPage(const NotificationsPage(), context),
                          child: const Padding(padding: EdgeInsets.only(right: 24), child: Image(image: AssetImage('Assets/alert.png'), height: 30, width: 30)))
                    ],
                    centerTitle: true,
                    expandedHeight: 60,
                    elevation: 20,
                    shadowColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.amber),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == 0) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('user_list').doc(userEmail).snapshots(),
                          builder: (context, snapshot) {
                            /*if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }*/
                            if (!snapshot.hasData) {
                              return const Center(child: Text('Account setup is incomplete'));
                            }
                            var data = snapshot.data!.data();
                            int star = data!['Star'];
                            int balance = data['Coin'];

                            return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: Column(children: [
                                    /// Balance display system
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: balanceShowChangeState,
                                            child: Container(
                                                width: 220,
                                                height: 50,
                                                decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(60)),
                                                child: Stack(alignment: Alignment.center, children: [
                                                  /// ৳ 50.00
                                                  AnimatedOpacity(
                                                      opacity: _isBalanceShown ? 1 : 0,
                                                      duration: const Duration(milliseconds: 500),
                                                      child: Text('৳ $balance', style: const TextStyle(color: Colors.pink, fontSize: 20))),

                                                  /// ব্যালেন্স দেখুন
                                                  AnimatedOpacity(
                                                      opacity: _isBalance ? 1 : 0,
                                                      duration: const Duration(milliseconds: 300),
                                                      child: const Text('Balance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 20))),

                                                  /// Circle icon
                                                  AnimatedPositioned(
                                                      duration: const Duration(milliseconds: 1100),
                                                      left: _isAnimated == false ? 10 : 170,
                                                      curve: Curves.fastOutSlowIn,
                                                      child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(50)),
                                                          child: const FittedBox(child: Text('৳', style: TextStyle(color: Colors.white, fontSize: 20))))),
                                                ])))),

                                    /// Profile Image
                                    /*
                                    Align(
                                        alignment: const AlignmentDirectional(0, 0),
                                        child: Stack(alignment: const AlignmentDirectional(0, 0), children: [
                                          Align(
                                              alignment: const AlignmentDirectional(0, 0),
                                              child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [Colors.teal, Colors.teal],
                                                          stops: [0, 1],
                                                          begin: AlignmentDirectional(0, -1),
                                                          end: AlignmentDirectional(0, 1)),
                                                      shape: BoxShape.circle),
                                                  child: Align(
                                                      alignment: const AlignmentDirectional(0, 0),
                                                      child: Container(
                                                          width: 110,
                                                          height: 110,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle),
                                                          child: CachedNetworkImage(
                                                              imageUrl: '$userImage', fit: BoxFit.cover)))))
                                        ])),
                                    */
                                    /// Name & Coin Card
                                    Card(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        color: Colors.white38,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                              child: Text('$userName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),

//////////////////////////////////////////////////////////////////////////////////////   Upgrade   ///////////////////////////////////////////////////////////////////////////
                                          InkWell(
                                              onTap: () {
                                                if (star < 10) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        int star1 = star + 1;
                                                        return AlertDialog(title: const Text("Upgrade"), content: Text('It will cost you ${star1 * 100}'), actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
///////////////////////////////////////////////////////////////////////       Upgrade Button Function      ////////////////////////////////////////////////////////////////////////////////
                                                                String? email = FirebaseAuth.instance.currentUser!.email;
                                                                int amount = star1 * 100;

                                                                if (amount <= balance) {
                                                                  FirebaseFirestore.instance.collection('user_list').doc(email).update({
                                                                    'Coin': FieldValue.increment(-amount),
                                                                    'Star': FieldValue.increment(1),
                                                                  }).onError((error, stackTrace) => showToast(error.toString()));

                                                                  FirebaseFirestore.instance.collection('user_list').doc(email).collection('Statement').doc().set({
                                                                    'amount': -amount,
                                                                    'type': 'Upgrade cost',
                                                                    'status': 'Done',
                                                                    'time': DateTime.now(),
                                                                  });

                                                                  FirebaseFirestore.instance.collection('Admin').doc('Money count').update({
                                                                    'Income': FieldValue.increment(amount),
                                                                  });

///////////////////////////////////////////////////////////////////////       Parent Commission      ////////////////////////////////////////////////////////////////////////////////
                                                                  FirebaseFirestore.instance.collection('user_list').doc(email).get().then((value) {
                                                                    List list = value['Parent List'];
                                                                    if (star < list.length) {
                                                                      var parent = list[list.length - star1];

                                                                      /// Indexing 0 number
                                                                      ///int parentNum = list.length - star1;
                                                                      int parentNum = star;

                                                                      /// ulta dik theke
                                                                      //showToast("$parent");

                                                                      DocumentReference documentReference000 =
                                                                          FirebaseFirestore.instance.collection('user_list').doc(parent);

                                                                      FirebaseFirestore.instance.runTransaction((transaction) async {
                                                                        DocumentSnapshot snapshot = await transaction.get(documentReference000);

                                                                        int parentStar = snapshot['Star'];
                                                                        List items = snapshot['Count'];
                                                                        if (parentStar >= star1) {
///////////////////////////////////////////////////////////////////////////////  Update Parent Coin  ////////////////////////////////////////////////////////////////
                                                                          int amnt = amount ~/ 2;
                                                                          if (parentNum == 0) {
                                                                            amnt = amount ~/ 2; // 0 index 50%
                                                                          } else if (parentNum == 1) {
                                                                            amnt = amount ~/ 2; // 1 index 50%
                                                                          } else if (parentNum == 2) {
                                                                            amnt = (amount * 2) ~/ 5; // 40%
                                                                          } else if (parentNum == 3) {
                                                                            amnt = (amount * 2) ~/ 5; // 30%
                                                                          } else if (parentNum == 4) {
                                                                            amnt = (amount * 3) ~/ 10; // 20%
                                                                          } else {
                                                                            amnt = amount ~/ 10; // Remains are 10%
                                                                          }

                                                                          //showToast("Amount : $amnt");
                                                                          transaction.update(documentReference000, {
                                                                            'Coin': FieldValue.increment(amnt),
                                                                            'Income': FieldValue.increment(amnt),
                                                                          });
//////////////////////////////////////////////////////////////////////////////   Update Parent Income Count   /////////////////////////////////////////////////////////////////
                                                                          ///
                                                                          items.replaceRange(star, star + 1, [items[star] + 1]);
                                                                          transaction.update(documentReference000, {'Count': items});
//////////////////////////////////////////////////////////////////////////////        Finish         /////////////////////////////////////////////////////////////////
                                                                          FirebaseFirestore.instance
                                                                              .collection('user_list')
                                                                              .doc(parent)
                                                                              .collection('Statement')
                                                                              .doc()
                                                                              .set({'amount': amnt, 'type': 'Income', 'status': 'Added', 'time': DateTime.now()});

                                                                          FirebaseFirestore.instance.collection('Admin').doc('Money count').update({
                                                                            'Income': FieldValue.increment(-amnt),
                                                                          });
//////////////////////////////////////////////////////////////////////////////        Finish         /////////////////////////////////////////////////////////////////
                                                                        }
                                                                      }).onError((error, stackTrace) => showToast(error.toString()));
                                                                    }
                                                                  }).onError((error, stackTrace) => showToast(error.toString()));

///////////////////////////////////////////////////////////////////////       Upgrade Button Function End      ////////////////////////////////////////////////////////////////////////////////
                                                                } else {
                                                                  showToast('Insufficient Balance');
                                                                }
                                                              },
                                                              child: const Text('Confirm'))
                                                        ]);
                                                      });
                                                }
                                              },
                                              child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                                                    Padding(
                                                        padding: const EdgeInsets.all(4),
                                                        child:
                                                            Text('$star', textAlign: TextAlign.start, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                                                    const Icon(Icons.stars, color: Colors.amber, size: 32),
                                                    /*Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                                  child: FutureBuilder(
                                                    future: FirebaseFirestore.instance
                                                        .collection('user_list')
                                                        .doc(userEmail)
                                                        .get().then((value) => null),
                                                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                      final data = snapshot.data;
                                                      return Text(
                                                        "$data['Star']",
                                                        textAlign: TextAlign.start,
                                                        style:
                                                            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                      );
                                                    },
                                                  ),
                                                ),*/
                                                  ])))

////////////////////////////////////////////////////////////////////////////////////////   Upgrade End  ///////////////////////////////////////////////////////////////////////////
                                        ]))
                                  ])),
                              //const Divider(thickness: 1, color: Colors.white38),

////////////////////////////////////////////////////////////////////////////////////////   Notice   ///////////////////////////////////////////////////////////////////////////
                              /// Notice
                              if (data['Notice'] != '')
                                Column(children: [
                                  const Text('Request:'),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16),
                                    child: Text('Email: ${data['Notice']} wants to be under your account'),
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    ElevatedButton(onPressed: () => updateReferral2(data['Notice']), child: const Text('Accept')),
                                    const SizedBox(width: 10),
                                    ElevatedButton(onPressed: () => rejectReferral(data['Notice']), child: const Text('Reject'))
                                  ]),
                                ]),
////////////////////////////////////////////////////////////////////////////////////////   Notice   ///////////////////////////////////////////////////////////////////////////
                              //const Divider(thickness: 1, color: Colors.white38),
                              /// Icons
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      int cnt = 3;
                                      if (constraints.maxWidth > 500) cnt = 3;
                                      if (constraints.maxWidth > 800) cnt = 5;
                                      return GridView(
                                          padding: EdgeInsets.zero,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: cnt, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          //scrollDirection: Axis.vertical,
                                          children: [
                                            /// Add Money
                                            FloatingActionButton.large(
                                              heroTag: '0011',
                                              onPressed: () => nextPage(PaymentGatewayWidget(operation: "Add Money", balance: 0, star: star), context),
                                              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Image(image: AssetImage("Assets/icons/AddMoney.png"), height: 60, width: 60),
                                                Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Add Money'))
                                              ]),
                                            ),

                                            /// Withdraw
                                            FloatingActionButton.large(
                                              onPressed: () => nextPage(PaymentGatewayWidget(operation: 'Withdraw', balance: balance, star: star), context),
                                              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Image(image: AssetImage("Assets/icons/Withdraw.png"), height: 60, width: 60),
                                                Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Withdraw'))
                                              ]),
                                            ),

                                            /// Transfer
                                            FloatingActionButton.large(
                                                onPressed: () {
                                                  if (star < 3) {
                                                    showToast("Needs minimum 3 star to enable this function");
                                                  } else {
                                                    nextPage(TransferWidget(balance: balance, star: star), context);
                                                  }
                                                },
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(image: AssetImage("Assets/icons/Transfer.png"), height: 60, width: 60),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Transfer'))
                                                ])),

                                            /// Income
                                            FloatingActionButton.large(
                                                onPressed: () => nextPage(const IncomeWidget(), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Income.png")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Income'))
                                                ])),

                                            /// Members
                                            FloatingActionButton.large(
                                                onPressed: () => nextPage(OneLevelMember(email: "$userEmail"), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Members.png")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Members'))
                                                ])),

                                            /// Games
                                            FloatingActionButton.large(
                                                onPressed: () => nextPage(const GamePageWidget(title: 'Game'), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Games.png")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Games'))
                                                ])),

                                            /// Gold Coin
                                            FloatingActionButton.large(
                                                onPressed: () => nextPage(GoldCoinPage(star: star), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Gold Coin.png")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Gold Coin'))
                                                ])),

                                            /// Google Ads
                                            FloatingActionButton.large(
                                                onPressed: () => nextPage(const AdmobPage(), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Google Ads.png")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Google Ads'))
                                                ])),

                                            /// Support
                                            FloatingActionButton.large(
                                                onPressed: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                          child: InteractiveViewer(
                                                              panEnabled: false, // Set it to false
                                                              boundaryMargin: const EdgeInsets.all(10),
                                                              minScale: 0.5,
                                                              maxScale: 2,
                                                              child: Image.asset("Assets/Contact.jpeg", fit: BoxFit.fitWidth)));
                                                    }),
                                                //onPressed: () => nextPage(const GamePageWidget(title: 'Support'), context),
                                                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Image(height: 60, width: 60, image: AssetImage("Assets/icons/Support.webp")),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), child: Text('Support'))
                                                ])),
                                          ]);
                                    },
                                  )),
                              const Divider(thickness: 1, color: Colors.white38),
                              ListView(shrinkWrap: true, children: [
                                CarouselSlider(
                                    items: imgList
                                        .map((e) => Container(
                                            margin: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0), image: DecorationImage(image: AssetImage(e.toString()), fit: BoxFit.cover))))
                                        .toList(),
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      height: 180.0,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                      viewportFraction: 0.8,
                                      onPageChanged: (index, reason) {
                                        setState(() => _current = index);
                                      },
                                    ))
                              ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.asMap().entries.map((entry) {
                                  return GestureDetector(
                                      onTap: () => _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                      ));
                                }).toList(),
                              ),
                              /*
                              Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.black,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: Stack(alignment: const AlignmentDirectional(0, 1), children: [
                                    Opacity(
                                        opacity: 0.8,
                                        child: Image.network(
                                            'https://images.unsplash.com/photo-1579621970588-a35d0e7ab9b6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxtb25leXxlbnwwfHx8fDE2OTM2OTY0MDJ8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover)),
                                    Opacity(
                                        opacity: 0.6,
                                        child: Align(
                                            alignment: const AlignmentDirectional(-0.01, 0.81),
                                            child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 4,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8)),
                                                    child: const Padding(
                                                        padding: EdgeInsets.all(3.0),
                                                        child: Text('Made by BDGameHubs',
                                                            style: TextStyle(
                                                                fontFamily: 'Plus Jakarta Sans',
                                                                color: Colors.teal,
                                                                fontWeight: FontWeight.bold)))))))
                                  ]))
                              */
                            ]);
                          });
                    }

                    return null;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<String> imgList = [
  "Assets/icons/card.png",
  "Assets/icons/chess.png",
  "Assets/icons/ludo.png",
  "Assets/icons/poster.jpg",
];
