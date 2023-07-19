import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:phonepe_gateway/model/phonepe_params_card.dart';
import 'package:phonepe_gateway/model/upi.dart';

import 'phonepe_gateway_platform_interface.dart';

/// An implementation of [PhonepeGatewayPlatform] that uses method channels.
class MethodChannelPhonepeGateway extends PhonepeGatewayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('phonepe_gateway');
  // final methodChannel = const MethodChannel('phonepe_gateway');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future getUpi() async {
    final version = await methodChannel.invokeMethod('getUpi');
    return version;
  }

  @override
  Future payWIthUpi({
    required UpiParams upiParams,
  }) async {
    final version = await methodChannel.invokeMethod('payWIthUpi', {
      'packageName': upiParams.packageName,
      "merchantTransactionId": upiParams.merchantTransactionId,
      "merchantUserId": upiParams.merchantUserId,
      "merchantId": upiParams.merchantId,
      "amount": upiParams.amount,
      "mobileNumber": upiParams.mobileNumber,
      "callbackUrl": upiParams.callbackUrl,
      "salt": upiParams.salt,
      "saltIndex": upiParams.saltIndex,
    });
    return version;
  }

  @override
  Future<String?> payWIthIntent(
      {required String intentUrl, String? packageName}) async {
    return await methodChannel.invokeMethod(
        'payWIthIntent', {'intentUrl': intentUrl, 'packageName': packageName});
  }

  @override
  Future<String?> payWithCard({
    required CardParams upiParams,
  }) async {
    final version = await methodChannel.invokeMethod('payWithCard', {
      "cardNumber": upiParams.cardDetails!.cardNumber,
      "cardExpiryMonth": upiParams.cardDetails!.cardExpiryMonth,
      "cardExpiryYear": upiParams.cardDetails!.cardExpiryYear,
      "cardCvv": upiParams.cardDetails!.cardCvv,
      "cardHolderName": upiParams.cardDetails!.cardHolderName,
      "merchantTransactionId": upiParams.merchantTransactionId,
      "merchantUserId": upiParams.merchantUserId,
      "merchantId": upiParams.merchantId,
      "amount": upiParams.amount,
      "mobileNumber": upiParams.mobileNumber,
      "callbackUrl": upiParams.callbackUrl,
      "salt": upiParams.salt,
      "saltIndex": upiParams.saltIndex,
    });
    return version;
  }
}
