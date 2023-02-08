import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class wuziqi extends StatefulWidget {
  @override
  _wuziqiState createState() => _wuziqiState();
}

class _wuziqiState extends State<wuziqi> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(
              'http://express.web-framework-ecpd.1635718952176230.cn-beijing.fc.devsapp.net/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'http://express.web-framework-ecpd.1635718952176230.cn-beijing.fc.devsapp.net/'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('五子棋')),
      body: WebViewWidget(controller: controller),
    );
  }
}
