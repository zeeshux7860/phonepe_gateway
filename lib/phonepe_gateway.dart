import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepe_gateway/model/hash.dart';
import 'package:phonepe_gateway/model/payment_complete.dart';
import 'package:phonepe_gateway/model/upi.dart';
import 'package:phonepe_gateway/phonepe_ui.dart';
import 'package:toast/toast.dart';
import "package:http/http.dart" as http;
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
      var response = await http.post(Uri.parse("http://43.204.12.176/test"),
          headers: {
            "X-VERIFY": hashRequest.checksum!,
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "request": hashRequest.base64Body,
          }));
      // print("==================================");
      // print(response.body);
      // print("==================================");
      HashResponse hashResponse =
          HashResponse.fromJson(jsonDecode(response.body));
      if (hashResponse.success == true) {
        // await init(upiParams.context);
        Toast.show(hashResponse.message!,
            duration: Toast.lengthShort, gravity: Toast.bottom);
        var data = await PhonepeGatewayPlatform.instance.payWIthIntent(
            intentUrl: hashResponse.data!.instrumentResponse!.intentUrl!,
            packageName: hashRequest.packageName);
        return PaymentMethod.fromJson(jsonDecode(data!));
      } else {
        Toast.show(hashResponse.message!,
            duration: Toast.lengthShort, gravity: Toast.bottom);
        return PaymentMethod.fromJson({
          "Status": "Failed",
          "Message": hashResponse.message,
        });
      }
    } else {
      Toast.show("Something went to wrongs",
          duration: Toast.lengthShort, gravity: Toast.bottom);
      return PaymentMethod.fromJson({
        "Status": "Failed",
        "Message": "Something went to wrongs",
      });
    }
  }

  Future init(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PhonePeUI()));
  }
}
