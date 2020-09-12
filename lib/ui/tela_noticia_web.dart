

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

String linkWeb;

class TelaNoticiaWeb extends StatefulWidget {

  TelaNoticiaWeb(String link) {
    linkWeb = link;
  }

  @override
  _TelaNoticiaWebState createState() => _TelaNoticiaWebState();
}

class _TelaNoticiaWebState extends State<TelaNoticiaWeb> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notícia web"),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: linkWeb,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
