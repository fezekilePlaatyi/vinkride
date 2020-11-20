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

    var title = "Payment - Amout : ";
    var selectedUrl = paymentUrl;

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
                      if (request.url.startsWith(
                          'https://us-central1-vink8-za.cloudfunctions.net/app/')) {
                        print("Blocked to navigate $request");

                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;
                        var paymentStatus = params['payment_status'];

                        print("Payment Status: $paymentStatus");
                        List url = paymentStatus.split(',');
                        print('Payment status after spliting: ${url[0]}');

                        // Map<dynamic, dynamic> messageObject = {
                        //   'feedData': feedData,
                        //   'message': url[0] == 'success'
                        //       ? 'Successfuly deducted the trip fare. Thank you!'
                        //       : 'An error occured while doing deduction on card: ${url[0]}'
                        // };

                        print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => DisplaySuccessMessages(
                        //             messageObject: messageObject)));

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
