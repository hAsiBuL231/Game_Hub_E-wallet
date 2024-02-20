import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gamehub2/Admob/webViewProvider.dart';
import 'package:gamehub2/All%20Functions%20Page/Functions.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  String token = "sdfsdf";

  Future<String?> tokenFunc() async {
    String? userToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    print(' \n \n \n User Token: $userToken \n \n \n ');
    return userToken;
    token = userToken!;
    //showToast(token);
  }

  @override
  Widget build(BuildContext context) {
    final countProvider = Provider.of<WebViewProvider>(context, listen: false);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        //onProgress: (progress) => const CircularProgressIndicator(color: Colors.blue),
        onProgress: (progress) => countProvider.setValue(progress / 100),
        onPageStarted: (url) => const CircularProgressIndicator(color: Colors.blue),
      ));

    return FutureBuilder(
      future: tokenFunc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // token is fetched, load the web view
          controller.loadRequest(Uri.parse("https://travel.codecastel.com/task-page?token=${snapshot.data}"));
          return Stack(children: [
            WebViewWidget(controller: controller),
            Consumer<WebViewProvider>(
              builder: (context, value, child) {
                if (value.progress != 1) {
                  //showToast(value.progress.toString());
                  return Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: LinearProgressIndicator(value: value.progress)));
                  return const Center(child: CircularProgressIndicator(color: Colors.blue));
                } else {
                  return Container();
                }
              },
            )
          ]);
          return WebViewWidget(controller: controller);
        } else if (snapshot.hasError) {
          // token fetch failed, show an error message
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          // token fetch is in progress, show a loading indicator
          //return const Center(child: Text("Loading...",softWrap: true,style: TextStyle(color: Colors.white)));
          return const Center(child: CircularProgressIndicator(color: Colors.blue));
        }
      },
    );
  }
}

/*

@override
  Widget build(BuildContext context) {
    tokenFunc();
    showToast(token);
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) => const CircularProgressIndicator(color: Colors.blue),
        onPageStarted: (url) => const CircularProgressIndicator(color: Colors.blue),
      ))
      ..loadRequest(Uri.parse("https://travel.codecastel.com/task-page?token=$token"));

    //..loadRequest(Uri.parse("https://travel.codecastel.com/task-page?token=${FirebaseAuth.instance.currentUser!.uid}"));
    return WebViewWidget(controller: controller);
  }
}

 */
