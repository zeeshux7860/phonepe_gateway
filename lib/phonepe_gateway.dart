import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepe_gateway/model/upi.dart';
import 'package:phonepe_gateway/phonepe_ui.dart';

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

  Future payWIthUpi({
    required UpiParams upiParams,
  }) async {
    var data =
        await PhonepeGatewayPlatform.instance.payWIthUpi(upiParams: upiParams);
  }

  Future init(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PhonePeUI()));
  }
}
