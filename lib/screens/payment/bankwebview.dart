import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BankWebView extends StatefulWidget {
  final String url;

  BankWebView(this.url);

  @override
  State<StatefulWidget> createState() => _BankWebView();
}

class _BankWebView extends State<BankWebView> {
  final webViewController =  WebViewController();

  @override
  void initState() {
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: WebViewWidget(controller: webViewController

      ),
    );
  }
}