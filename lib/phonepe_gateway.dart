import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_gateway/model/card_model.dart';
import 'package:phonepe_gateway/model/hash.dart';
import 'package:phonepe_gateway/model/payment_complete.dart';
import 'package:phonepe_gateway/model/upi.dart';
import 'package:phonepe_gateway/phonepe_ui.dart';
import 'package:phonepe_gateway/web_view/view.dart';
import 'package:toast/toast.dart';
import "package:http/http.dart" as http;
import 'model/phonepe_params_card.dart';
import 'model/phonepe_params_upi.dart';
import 'phonepe_gateway_platform_interface.dart';

class PhonepeGateway {
  Future<String?> getPlatformVersion() {
    return PhonepeGatewayPlatform.instance.getPlatformVersion();
  }

  Future<UPI> getUpi() async {
    var data = await PhonepeGatewayPlatform.instance.getUpi();
    UPI upi = UPI.fromJson(jsonDecode(data));
    return upi;
  }

  Future<PaymentMethod> payWIthUpi({
    required UpiParams upiParams,
  }) async {
    var data =
        await PhonepeGatewayPlatform.instance.payWIthUpi(upiParams: upiParams);
    HashRequest hashRequest = HashRequest.fromJson(jsonDecode(data));
    if (hashRequest.status == true) {
      return paymentComplete(hashRequest);
    } else {
      Toast.show("Something went to wrongs",
          duration: Toast.lengthShort, gravity: Toast.bottom);
      return PaymentMethod.fromJson({
        "Status": "Failed",
        "Message": "Something went to wrongs",
      });
    }
  }

  Future init(BuildContext context, ParamsPayment params) async {
    await Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => PhonePeUI(
              params: params,
            )));
  }

  Future<PaymentMethod> payWithCard(
      {required CardParams cardParams, required BuildContext context}) async {
    var data = await PhonepeGatewayPlatform.instance
        .payWithCard(upiParams: cardParams);
    HashRequest hashRequest = HashRequest.fromJson(jsonDecode(data!));
    if (hashRequest.status == true) {
      return paymentComplete(hashRequest, context: context);
    } else {
      Toast.show("Something went to wrongs",
          duration: Toast.lengthShort, gravity: Toast.bottom);
      return PaymentMethod.fromJson({
        "Status": "Failed",
        "Message": "Something went to wrongs",
      });
    }
  }

  Future<PaymentMethod> paymentComplete(HashRequest hashRequest,
      {BuildContext? context}) async {
    var response = await http.post(
        Uri.parse(PhonpePaymentGateway.instance.phonePeConfig.baseUrl!),
        headers: {
          "X-VERIFY": hashRequest.checksum!,
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode({
          "request": hashRequest.base64Body,
        }));
    HashResponse hashResponse =
        HashResponse.fromJson(jsonDecode(response.body));
    if (hashResponse.success == true) {
      // await init(upiParams.context);
      Toast.show(hashResponse.message!,
          duration: Toast.lengthShort, gravity: Toast.bottom);

      if (hashResponse.data!.instrumentResponse!.intentUrl != null) {
        var data = await PhonepeGatewayPlatform.instance.payWIthIntent(
            intentUrl: hashResponse.data!.instrumentResponse!.intentUrl!,
            packageName: hashRequest.packageName);
        return PaymentMethod.fromJson(jsonDecode(data!));
      } else {
        var data = await Navigator.push(context!, CupertinoPageRoute(
          builder: (context) {
            return WebViewExample(
                url: hashResponse.data!.instrumentResponse!.redirectInfo!.url!);
          },
        ));
        if (data != null) {
          var py = PaymentWithCardModel.fromJson(json.decode(data));
          var paymentData = PaymentMethod(
              approvalRefNo: py.providerReferenceId,
              message: py.code,
              status: py.code == "PAYMENT_SUCCESS"
                  ? "Success"
                  : py.code == "PAYMENT_ERROR"
                      ? "Failed"
                      : py.code,
              txnId: py.transactionId,
              response: py.code == "PAYMENT_SUCCESS"
                  ? "Success"
                  : py.code == "PAYMENT_ERROR"
                      ? "Failed"
                      : py.code);
          // debugPrint(paymentData.toJson().toString());
          return paymentData;
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Transation Cancelled"),
                    content: const Text("ERROR"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Toast.show("Payment Cancelled.",
                              duration: Toast.lengthShort,
                              gravity: Toast.bottom);

                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ));
          PhonpePaymentGateway.instance
              .cancelPayment("Payment Cancelled by User.");
          return PaymentMethod();
        }
      }
    } else {
      Toast.show(hashResponse.message!,
          duration: Toast.lengthShort, gravity: Toast.bottom);
      return PaymentMethod.fromJson({
        "Status": "Failed",
        "Message": hashResponse.message,
      });
    }
  }
}
