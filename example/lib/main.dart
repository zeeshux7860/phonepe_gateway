import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:phonepe_gateway/model/phonepe_config.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/phonepe_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PayUI(),
    );
  }
}

class PayUI extends StatefulWidget {
  const PayUI({super.key});

  @override
  State<PayUI> createState() => _PayUIState();
}

class _PayUIState extends State<PayUI> {
  // final _phonepeGatewayPlugin = PhonepeGateway();
  @override
  void initState() {
    // PhonpePaymentGateway.instance.init(
    //     config: PhonePeConfig(
    //         redirectUrl: "http://127.0.0.1/test/view",
    //         baseUrl: "http://127.0.0.1/test",
    //         appName: "PhonePe Test App",
    //         callBackUrl:
    //             "https://webhook.site/845cb8cc-5d74-4494-95ea-3003c9c518ab",
    //         merchanId: "************",
    //         saltIndex: 1,
    //         saltKey: "********-****-****-****-***********"));
    PhonpePaymentGateway.instance.init(
        config: PhonePeConfig(
            redirectUrl: "https://api-v1.voiceclub.app/test/view",
            baseUrl: "https://api-v1.voiceclub.app/test",
            appName: "PhonePe Test App",
            callBackUrl:
                "https://webhook.site/845cb8cc-5d74-4494-95ea-3003c9c518ab",
            merchanId: "VOICECLUBONLINE",
            saltIndex: 1,
            saltKey: "a9e8cbaf-c914-48ec-80db-3b9f19e745f1"));
    PhonpePaymentGateway.instance.handlerCancelled(
      (value) {
        showPaymentAlertDialog("Cancelled :${jsonEncode(value.toJson())}");
      },
    );
    PhonpePaymentGateway.instance.handlerFailed(
      (value) {
        showPaymentAlertDialog("Failed :${jsonEncode(value.toJson())}");
      },
    );

    PhonpePaymentGateway.instance.handlerSuccess(
      (value) {
        showPaymentAlertDialog("Success :${jsonEncode(value.toJson())}");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            PhonpePaymentGateway.instance.initPayment(context,
                params: ParamsPayment(
                    amount: 1,
                    merchantTransactionId:
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    merchantUserId: "1234567890",
                    mobileNumber: "1234567890",
                    notes: {
                      "uid": "1234567890",
                      "name": "Test User",
                      "email": "example#example.com"
                    }));
          },
          child: const Icon(Icons.add),
        ));
  }

  void showPaymentAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Status"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

// Function to show the payment alert dialog

