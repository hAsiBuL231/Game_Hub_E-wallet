import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'Admob/webViewProvider.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';

//String? userEmail = FirebaseAuth.instance.currentUser?.email;
//String? userName = FirebaseAuth.instance.currentUser?.displayName;
//String? userImage = FirebaseAuth.instance.currentUser?.photoURL;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);
  } catch (e) {
    if (kDebugMode) {
      print(' \n \n Printing From App: Error during Firebase initialization: \n $e \n \n ');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WebViewProvider()),
      ],
      child: MaterialApp(
        title: 'Game Hub Beta',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: GoogleFonts.outfit().fontFamily,
          textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreenWidget(),
      ),
    );
  }
}
