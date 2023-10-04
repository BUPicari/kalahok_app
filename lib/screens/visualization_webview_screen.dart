import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kalahok_app/helpers/variables.dart';

class VisualizationWebViewScreen extends StatefulWidget {
  const VisualizationWebViewScreen({Key? key,}) : super(key: key);

  @override
  State<VisualizationWebViewScreen> createState() => _VisualizationWebViewScreenState();
}

class _VisualizationWebViewScreenState extends State<VisualizationWebViewScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();

        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(ApiConfig.visualizationUrl)
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  inAppWebViewController = controller;
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
              _progress < 1 ? Container (
                child: LinearProgressIndicator(
                  value: _progress,
                ),
              ) : const SizedBox()
            ],
          ),
        )
      )
    );
  }
}
