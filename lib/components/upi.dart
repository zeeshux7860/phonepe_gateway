import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:phonepe_gateway/model/payment_complete.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/model/upi.dart';
import 'package:phonepe_gateway/phonepe_gateway.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

import '../provider/config.dart';

class UpiWidget extends StatefulWidget {
  final ParamsPayment paramsUpi;
  const UpiWidget({super.key, required this.paramsUpi});

  @override
  State<UpiWidget> createState() => _UpiWidgetState();
}

class _UpiWidgetState extends State<UpiWidget> {
  final _phonepeGatewayPlugin = PhonepeGateway();
  UPI? dsValue;
  @override
  void initState() {
    _phonepeGatewayPlugin.getUpi().then((value) {
      setState(() {
        dsValue = value;
      });
    });
    super.initState();
  }

  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return dsValue == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[50]!,
            highlightColor: Colors.grey[200]!,
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('PhonePe'),
                  );
                },
              ),
            ),
          )
        : SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dsValue!.listOfUpi!.length,
              itemBuilder: (context, index) {
                var value = dsValue!.listOfUpi![index];

                return FutureBuilder(
                    future: getIcon(value.packageName!),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.all(10),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  sendRequest(value);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.memory(snapshot.data ?? Uint8List(0),
                                        height: 50, width: 50),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      value.applicationName!,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    });
              },
            ),
          );
  }

  Future<void> sendRequest(ListOfUpi value) async {
    Uri maptoConvertUri;

    if (widget.paramsUpi.notes != null) {
      maptoConvertUri = Uri(queryParameters: widget.paramsUpi.notes!);
    } else {
      maptoConvertUri = Uri(queryParameters: {});
    }
    var data = await _phonepeGatewayPlugin.payWIthUpi(
        upiParams: UpiParams(
            amount: (widget.paramsUpi.amount! * 100).toInt(),
            callbackUrl:
                "${PhonpePaymentGateway.instance.phonePeConfig.callBackUrl}?${maptoConvertUri.query}",
            merchantTransactionId: widget.paramsUpi.merchantTransactionId,
            merchantUserId: widget.paramsUpi.merchantUserId,
            mobileNumber: widget.paramsUpi.mobileNumber,
            packageName: value.packageName,
            merchantId: PhonpePaymentGateway.instance.phonePeConfig.merchanId,
            salt: PhonpePaymentGateway.instance.phonePeConfig.saltKey,
            saltIndex: PhonpePaymentGateway.instance.phonePeConfig.saltIndex!
                .toInt()));
    if (data.status == "Success") {
      back();
      Toast.show("Payment Successfull",
          duration: Toast.lengthShort, gravity: Toast.bottom);
      PhonpePaymentGateway.instance.successPayment(data);
    } else {
      // failed payment alert
      print(data.status);
      if (data.message == null) {
        if (data.status == "Failed") {
          Toast.show("Payment $data.status",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          PhonpePaymentGateway.instance.failedPayment(PaymentMethod(
            status: data.status,
            message: data.message,
          ));
          back();
        } else if (data.status == "FAILURE") {
          Toast.show("Payment $data.status",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          PhonpePaymentGateway.instance.failedPayment(PaymentMethod(
            status: data.status,
            message: "Payment ${data.status}",
          ));
          back();
        } else {
          Toast.show("Payment Cancelled",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          PhonpePaymentGateway.instance.failedPayment(PaymentMethod(
            status: "Cancelled",
            message: "Payment Cancelled",
          ));
          back();
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Payment Failed"),
                content: Text(data.message.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
        PhonpePaymentGateway.instance.failedPayment(data);
      }
    }
  }

  Future<Uint8List> getIcon(String packageName) async {
    var ds = await InstalledApps.getAppInfo(packageName);
    return ds.icon!;
  }
}
