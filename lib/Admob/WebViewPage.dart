import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;
  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) => const CircularProgressIndicator(color: Colors.blue),
        onPageStarted: (url) => const CircularProgressIndicator(color: Colors.blue),
      ))
      ..loadRequest(Uri.parse(widget.url));

    return WebViewWidget(controller: controller);
  }
}
