import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const GloovApp());
}

class GloovApp extends StatelessWidget {
  const GloovApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gloov',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const GloovWebView(),
    );
  }
}

class GloovWebView extends StatefulWidget {
  const GloovWebView({super.key});
  @override
  State<GloovWebView> createState() => _GloovWebViewState();
}

class _GloovWebViewState extends State<GloovWebView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://gloomaps.com'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
