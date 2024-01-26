import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void nextPage(page, context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void newPage(page, context) {
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => page), (route) => false);
}

snackBar(String message, context) {
  //final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  var snackDemo = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(message),
    backgroundColor: Colors.blue,
    elevation: 15,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(20),
  );
  //ScaffoldMessenger.of(context).showSnackBar(snackDemo);
  //scaffoldMessengerKey.currentState!.showSnackBar(snackDemo);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackDemo);
  });
}

dialog(message, context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: message,
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Accept')),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Reject'))
          ],
        );
      });
}

showToast(String message) {
  if (kDebugMode) {
    print(" \n \n Print: \n $message \n ");
  }
  Fluttertoast.showToast(
      msg: message,
      fontSize: 18,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      gravity: ToastGravity.SNACKBAR,
      webPosition: 'center',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 3);
}

timeFormat(Timestamp time) {
  DateTime now = time.toDate();
  String convertedTime = "${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  String convertedDate = "${now.year.toString()}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  String convertedDateTime = "$convertedTime  $convertedDate";
  return convertedDateTime;
}

/*(Timestamp _time) {
  DateTime joinTime = _time.toDate();
  //var joinTime = _time.toString();
  DateTime time = DateTime.now();
  DateTime currentDate = DateTime(time.year, time.month, time.day);
  int diff1 = time.difference(joinTime).inDays;
  joinTime = joinTime.subtract(Duration(days: diff1));
  int diff2 = time.difference(joinTime).inHours;
  //String diff2 = time.difference(joinTime).inHours.toString();
  //String diff2 = DateTime.now().difference(time).inHours.toString();
  String diff= "$diff1.$diff2";
  return diff;
}*/

/*_getData() async {
    userEmail = FirebaseAuth.instance.currentUser?.email;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user_list')
        .where(FieldPath([userEmail!]))
        .get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      var data = queryDocumentSnapshot.data();
      setState(() {
        phone = data['phone'];
        profession = data['profession'];
        location = data['location'];
        dob = data['dob'];
        language = data['language'];
        Timestamp getTime = data['joined'];
        DateTime joinTime = getTime.toDate();
        joined = joinTime.toString();
        DateTime time = DateTime.now();
        DateTime currentDate = DateTime(time.year, time.month, time.day);
        difference = currentDate.difference(joinTime).inDays.toString();
      });
    }
    return;
  }*/
