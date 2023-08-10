import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonepe_gateway/components/card.dart';
import 'package:phonepe_gateway/components/upi.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/provider/config.dart';
import 'package:toast/toast.dart';
export 'provider/config.dart';
// export './model//phonepe_config.dart';
// export './model//phonepe_params_upi.dart';

class PhonePeUI extends StatefulWidget {
  final ParamsPayment params;
  const PhonePeUI({super.key, required this.params});

  @override
  State<PhonePeUI> createState() => _PhonePeUIState();
}

class _PhonePeUIState extends State<PhonePeUI> {
  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return WillPopScope(
      onWillPop: () {
        SystemChrome.restoreSystemUIOverlays();
        // are you sure you want to cancel the payment? alert dialog
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Cancel Payment?"),
                  content: const Text(
                      "Are you sure you want to cancel the payment?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Toast.show("Payment Cancelled.",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                        PhonpePaymentGateway.instance
                            .cancelPayment("Payment Cancelled by User.");
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          elevation: 0.1,
          backgroundColor: Colors.white,
          title: const Text(
            'PhonePe Gateway',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            // amount
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "₹ ${(widget.params.amount!)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "UPI Apps",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              UpiWidget(
                paramsUpi: widget.params,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Card & Netbanking",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CreditDebitCard(params: widget.params),
              )
            ],
          ),
        ),
      ),
    );
  }
}
