import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passenger/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  var paymentUrl;
  Payment({this.paymentUrl});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var paymentUrl = widget.paymentUrl;

    var title = "Trip Payment";
    var selectedUrl = paymentUrl;
    var baseURL = Constants.PAYMENT_SERVER_ADDRESS;

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      child: WebView(
                    initialUrl: selectedUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    javascriptChannels: <JavascriptChannel>[
                      _toasterJavascriptChannel(context),
                    ].toSet(),
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url
                          .startsWith('$baseURL/payment/paymentSuccess')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;

                        print("Successfuly paid");
                        print(params);

                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith('$baseURL/payment/paymentError')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;

                        print("Error Payment");
                        print(params);

                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith('$baseURL/payment/paymentCancelation')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;

                        print("Cancelled Payment");
                        print(params);

                        return NavigationDecision.prevent;
                      }

                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  )),
                ),
              ],
            )
          ],
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
