import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Auth/AuthTree.dart';
import '../Auth/CreateProfile.dart';
import '../Auth/VerifyEmail.dart';
import '../HomePage.dart';
import 'Functions.dart';

authentication(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('\n User is currently signed out! \n\n');
    newPage(const AuthTreeWidget(), context);
  } else {
    User? user = FirebaseAuth.instance.currentUser;
    String? userEmail = user!.email;
    String? userName = user.displayName;

    print('\n User is Signed in as: $userEmail! \n');
    showToast('Welcome Back, $userName!');

    if (!user.emailVerified) {
      newPage(const VerifyEmailWidget(), context);
    } else if (userName == null) {
      newPage(const CreateProfileWidget(), context);
    } else {
      newPage(const HomepageWidget(), context);
    }
  }
  return;
}

createDatabaseFunction(String userName, int phone, int uniqueID) async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  //  String ID = int.tryParse(userEmail!).toString();
  List<dynamic> parents = [];
  List<dynamic> child = [];
  List levels = List.filled(10, 0);
  List count = List.filled(10, 0);

  await FirebaseFirestore.instance.collection('user_list').doc(userEmail).set({
    'Parent List': parents,
    'Child List': child,
    'User Name': userName,
    'Phone': phone,
    'Star': 0,
    'Coin': 0,
    'Count': count,
    'Income': 0,
    'Notice': '',
    'Unique ID': uniqueID,
    'Level Count': levels,
  }).onError((error, stackTrace) {
    showToast(error.toString());
  });

  /*if (referral != '') {
    FirebaseFirestore.instance.collection('user_list').doc(referral).update({
      'Notice': userEmail,
    });
  }*/
}

updateReferral(String referral) async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  //  String ID = int.tryParse(userEmail!).toString();
  List<dynamic> parents = [];
  List<dynamic> child = [];

  if (referral != '') {
    try {
      await FirebaseFirestore.instance.collection('user_list').doc(userEmail).get().then((document) async {
        if (document.exists) {
          var data = document.data();
          parents = data!['Parent List'];
          child = data['Child List'];
          if (child.length < 5 && parents.length < 10) {
            child.add(referral);
            parents.add(userEmail);
          } else {
            parents = [];
          }
          await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({'Child List': child, 'Notice': ''});
        }
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  await FirebaseFirestore.instance.collection('user_list').doc(referral).update({'Parent List': parents}).onError((error, stackTrace) => showToast(error.toString()));

  //for (var element in parents) {}
  //parents.reversed.take(10).forEach((parent) {});
  for (int i = parents.length - 1; i >= 0 && i >= parents.length - 10; i--) {
    showToast("I is: $i");
    String email = parents[i];
    showToast("Parent is: $email");

    /*FirebaseFirestore.instance.collection("user_list").doc(email).get().then((value) {
      var data = value.data();
      List list = data!['Level Count'];
      list[parents.length - i] = FieldValue.increment(1);
    });*/

    DocumentReference documentReference = FirebaseFirestore.instance.collection('user_list').doc(email);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      List list = snapshot['Level Count'];
      //list[parents.length - (i + 1)] = FieldValue.increment(1); // works under update function
      list[parents.length - (i + 1)] = list[parents.length - (i + 1)] + 1;
      transaction.update(documentReference, {'Level Count': list});
    }).onError((error, stackTrace) => showToast(error.toString()));
  }
}

updateReferral2(String referral) async {
  /// Improved By ChatGPT
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  List<dynamic> parents = [];
  List<dynamic> child = [];

  if (referral != '') {
    try {
      await FirebaseFirestore.instance.collection('user_list').doc(userEmail).get().then((document) {
        if (document.exists) {
          var data = document.data();
          parents = data!['Parent List'];
          child = data['Child List'];
          if (child.length < 5 && parents.length < 10) {
            child.add(referral);
            parents.add(userEmail);
          } else {
            parents = [];
          }
        }
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  WriteBatch batch = FirebaseFirestore.instance.batch();

  batch.update(FirebaseFirestore.instance.collection('user_list').doc(userEmail), {'Child List': child, 'Notice': ''});
  batch.update(FirebaseFirestore.instance.collection('user_list').doc(referral), {'Parent List': parents});

  for (int i = parents.length - 1; i >= 0 && i >= parents.length - 10; i--) {
    String email = parents[i];

    DocumentReference documentReference = FirebaseFirestore.instance.collection('user_list').doc(email);
    DocumentSnapshot snapshot = await documentReference.get();
    List list = snapshot['Level Count'];
    list[parents.length - (i + 1)] = list[parents.length - (i + 1)] + 1;

    batch.update(documentReference, {'Level Count': list});
  }

  return batch.commit().catchError((error) => showToast(error.toString()));
}

rejectReferral(String referral) async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  List<dynamic> parents = [];
  await FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({'Notice': ''}).onError((error, stackTrace) => showToast(error.toString()));
  await FirebaseFirestore.instance.collection('user_list').doc(referral).update({'Parent List': parents}).onError((error, stackTrace) => showToast(error.toString()));
}

/*
updateDatabaseFunction(_userEmail, _field, _data) {
  FirebaseFirestore.instance.collection('user_list').doc(_userEmail).set(
    {
      '$_field': '$_data',
    },
    SetOptions(merge: true),
  ).onError((error, stackTrace) {
    SnackBar(content: Text('Error: $error'));
  });
}*/
/*
getStar() {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  var star = 'Star';
  /*FirebaseFirestore.instance.collection('user_list').doc(userEmail).snapshots().map((event) {
    var data = event.data();
    star = data!['Star'];
    return star;
  });*/

  FirebaseFirestore.instance.collection('user_list').doc(userEmail).get().then((DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      print("$key => $value");
      if (key == 'Star') star = '$value';
    });
    return star;
    //star = document.data()!['Star'];
    //var data = document.data();
    //star = data!['Star'];
  }).onError((error, stackTrace) {
    star = 'Error';
    return '$error';
  });
  return star;
}*/
/*
getData(_userEmail, _field) {
  /*var querySnapshot = FirebaseFirestore.instance.collection('user_list').doc(_userEmail).get();
  var data = querySnapshot.data();
  if (data != null) {
    if (data["$_field"] != null) gotData = data["$_field"];
  }*/
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  var gotData = "NoData";
  FirebaseFirestore.instance.collection('user_list').doc(userEmail).get().then((document) {
    var data = document.data();
    if (data != null) gotData = data['Star'];
    return gotData;
  }).onError((error, stackTrace) {
    SnackBar(content: Text('Error: $error'));
    return "$error";
  });
}*/
/*
getUsername(_userEmail) {
  var name = 'No name';

  FirebaseFirestore.instance.collection('user_list').doc(_userEmail).snapshots().map((event) {
    var data = event.data();
    //Map<String, dynamic>? data = document.data();
    name = data!['User Name'];
  });
  return name;

  /*
  FirebaseFirestore.instance.collection('user_list').doc(_userEmail).get().then((document) {
    var data = document.data();
    name = data!['User Name'];
  }).onError((error, stackTrace) {
    SnackBar(content: Text('Error: $error'));
    name = "$error";
  });
  return name;*/
}
 */
