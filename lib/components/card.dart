import 'package:flutter/material.dart';
import 'package:phonepe_gateway/phonepe_gateway.dart';
import 'package:phonepe_gateway/provider/config.dart';

import '../model/phonepe_params_card.dart';
import '../model/phonepe_params_upi.dart';

class CreditDebitCard extends StatefulWidget {
  final ParamsPayment params;
  const CreditDebitCard({super.key, required this.params});

  @override
  State<CreditDebitCard> createState() => _CreditDebitCardState();
}

class _CreditDebitCardState extends State<CreditDebitCard> {
  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final phonepeGatewayPlugin = PhonepeGateway();

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () async {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          Uri maptoConvertUri;

          if (widget.params.notes != null) {
            maptoConvertUri = Uri(queryParameters: widget.params.notes!);
          } else {
            maptoConvertUri = Uri(queryParameters: {});
          }
          var data = await phonepeGatewayPlugin.payWithCard(
              context: context,
              cardParams: CardParams(
                  redirectMode: "POST",
                  redirectUrl:
                      PhonpePaymentGateway.instance.phonePeConfig.redirectUrl!,
                  amount: (widget.params.amount! * 100).toInt(),
                  callbackUrl:
                      "${PhonpePaymentGateway.instance.phonePeConfig.callBackUrl}?${maptoConvertUri.query}",
                  merchantTransactionId: widget.params.merchantTransactionId,
                  merchantUserId: widget.params.merchantUserId,
                  mobileNumber: widget.params.mobileNumber,
                  merchantId:
                      PhonpePaymentGateway.instance.phonePeConfig.merchanId,
                  salt: PhonpePaymentGateway.instance.phonePeConfig.saltKey,
                  saltIndex: PhonpePaymentGateway
                      .instance.phonePeConfig.saltIndex!
                      .toString()));
          if (data.status == "SUCCESS") {
            PhonpePaymentGateway.instance.successPayment(data);
            back();
          } else {
            // failed payment alert
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
                          },
                          child: const Text("Ok"))
                    ],
                  );
                });
            PhonpePaymentGateway.instance.failedPayment(data);
          }
        },
        leading: const SizedBox(height: 40, child: Icon(Icons.credit_card)),
        title: const Text("Credit/Debit Card"),
        subtitle: const Text("Visa, MasterCard, Rupay & more"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
