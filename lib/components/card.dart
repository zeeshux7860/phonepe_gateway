import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_gateway/components/card/screens/new_card/add_new_card.dart';

import '../model/phonepe_params_upi.dart';

class CreditDebitCard extends StatelessWidget {
  final ParamsPayment params;
  const CreditDebitCard({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
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
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddNewCardScreen(params: params),
            ),
          );
        },
        leading: const SizedBox(height: 40, child: Icon(Icons.credit_card)),
        title: const Text("Credit/Debit Card"),
        subtitle: const Text("Visa, MasterCard, Rupay & more"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
