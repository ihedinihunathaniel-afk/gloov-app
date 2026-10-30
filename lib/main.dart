import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GloovApp());
}

class GloovApp extends StatelessWidget {
  const GloovApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GLOOV',
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
  bool isLoading = true;
  bool hasError = false;
  String errorMsg = '';

  // YOUR WEBSITE HERE - Change if needed
  final String websiteUrl = 'https://gloovph2026.tiiny.site';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMsg = '${error.errorCode}: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(websiteUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GLOOV'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          if (hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text('Cannot load website', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('URL: $websiteUrl', textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Text('Error: $errorMsg', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasError = false;
                          isLoading = true;
                        });
                        controller.loadRequest(Uri.parse(websiteUrl));
                      },
                      child: const Text('Retry'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.loadRequest(Uri.parse('https://www.google.com'));
                      },
                      child: const Text('Test with Google.com'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
