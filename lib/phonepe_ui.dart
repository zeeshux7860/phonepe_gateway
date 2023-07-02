import 'package:flutter/material.dart';
import 'package:phonepe_gateway/components/upi.dart';

class PhonePeUI extends StatefulWidget {
  const PhonePeUI({super.key});

  @override
  State<PhonePeUI> createState() => _PhonePeUIState();
}

class _PhonePeUIState extends State<PhonePeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "UPI Apps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            UpiWidget()
          ],
        ),
      ),
    );
  }
}
