import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class BankWebView extends StatefulWidget {
  final String url;

  BankWebView(this.url);

  @override
  State<StatefulWidget> createState() => _BankWebView();
}

class _BankWebView extends State<BankWebView> {
  WebViewPlusController? _webController;

  @override
  void initState() {
    // webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    // webViewController.loadRequest();
    // webViewController.addJavaScriptChannel('window.document.getElementsByTag(\'html\')[0].outerHTML;', onMessageReceived: (s) {
    //   print(s);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Container(
      color: Colors.green,
      child: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (c)  {_webController = c;
          _webController!.loadUrl(widget.url);
          },
        onPageFinished: (s) {
          _webController!.webViewController.runJavascriptReturningResult("window.document.getElementsByTagName('html')[0].outerHTML;").then((value) {
            if (value.contains('Payment success')) {
              Navigator.pop(context, true);
            }
          });
        },
      ),
    )));
  }
}