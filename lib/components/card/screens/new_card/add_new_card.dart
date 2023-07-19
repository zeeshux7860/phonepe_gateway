import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phonepe_gateway/components/card/constains.dart';
import 'package:phonepe_gateway/components/card/main.dart';
import 'package:phonepe_gateway/components/card/screens/new_card/components/card_type.dart';
import 'package:phonepe_gateway/components/card/screens/new_card/components/card_utilis.dart';
import 'package:phonepe_gateway/components/card/screens/new_card/components/input_formatters.dart';
import 'package:phonepe_gateway/model/phonepe_params_card.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/phonepe_gateway.dart';

import '../../../../provider/config.dart';

class AddNewCardScreen extends StatefulWidget {
  final ParamsPayment params;
  const AddNewCardScreen({Key? key, required this.params}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _phonepeGatewayPlugin = PhonepeGateway();
  @override
  void initState() {
    cardNumberController.addListener(() {
      getCardType();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();

    super.dispose();
  }

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardMonthController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  CardType cardType = CardType.Invalid;
  void getCardType() {
    if (cardNumberController.text.length <= 6) {
      var cardNumb = CardUtils.getCleanedNumber(cardNumberController.text);
      var type = CardUtils.getCardTypeFrmNumber(cardNumb);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  void back() {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "New Card",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      return null;
                    },
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter()
                    ],
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardUtils.getCardIcon(cardType),
                      ),
                      hintText: "Card Number",
                      prefixIcon: cardType == CardType.Invalid
                          ? null
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SvgPicture.asset(
                                "assets/icons/card.svg",
                              ),
                            ),

                      filled: true,
                      fillColor: const Color(0xFFF8F8F9),
                      hintStyle: const TextStyle(
                        color: Color(0xFFB8B5C3),
                      ),
                      border: defaultOutlineInputBorder,
                      enabledBorder: defaultOutlineInputBorder,
                      focusedBorder: defaultOutlineInputBorder,
//
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                        controller: cardNameController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.asset(
                              "assets/icons/user.svg",
                            ),
                          ),
                          hintText: "Full Name",
                          filled: true,
                          fillColor: const Color(0xFFF8F8F9),
                          hintStyle: const TextStyle(
                            color: Color(0xFFB8B5C3),
                          ),
                          border: defaultOutlineInputBorder,
                          enabledBorder: defaultOutlineInputBorder,
                          focusedBorder: defaultOutlineInputBorder,
                        )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter expiry date';
                              }
                              return null;
                            },
                            controller: cardMonthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter()
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SvgPicture.asset(
                                  "assets/icons/calender.svg",
                                ),
                              ),
                              hintText: "MM/YY",
                              filled: true,
                              fillColor: const Color(0xFFF8F8F9),
                              hintStyle: const TextStyle(
                                color: Color(0xFFB8B5C3),
                              ),
                              border: defaultOutlineInputBorder,
                              enabledBorder: defaultOutlineInputBorder,
                              focusedBorder: defaultOutlineInputBorder,
                            )),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter card cvv';
                              }
                              return null;
                            },
                            controller: cardCvvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SvgPicture.asset(
                                  "assets/icons/Cvv.svg",
                                ),
                              ),
                              hintText: "CVV",
                              filled: true,
                              fillColor: const Color(0xFFF8F8F9),
                              hintStyle: const TextStyle(
                                color: Color(0xFFB8B5C3),
                              ),
                              border: defaultOutlineInputBorder,
                              enabledBorder: defaultOutlineInputBorder,
                              focusedBorder: defaultOutlineInputBorder,
                            )),
                      ),
                    ],
                  )
                ],
              )),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
                "We accept Credit and Debit Cards from Visa, Rupay, MasterCard, Discover and American Express."),
          ),
          // secure card phonepe
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF8F8F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/secure.png",
                          height: 25,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        const Text(
                          "Secure",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF8F8F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/phonepe.png",
                          height: 25,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        const Text(
                          "PhonePe",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // OutlinedButton.icon(
          //     style: OutlinedButton.styleFrom(
          //       foregroundColor: Colors.black,
          //       minimumSize: const Size(double.infinity, 56),
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(12)),
          //       ),
          //     ),
          //     onPressed: () {},
          //     icon: SvgPicture.asset("assets/icons/scan.svg"),
          //     label: const Text("Scan")),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                Uri maptoConvertUri;

                if (widget.params.notes != null) {
                  maptoConvertUri = Uri(queryParameters: widget.params.notes!);
                } else {
                  maptoConvertUri = Uri(queryParameters: {});
                }
                var data = await _phonepeGatewayPlugin.payWithCard(
                    cardParams: CardParams(
                        cardDetails: CardDetails(
                            cardHolderName: cardNameController.text,
                            cardNumber: cardNumberController.text,
                            cardExpiryMonth:
                                cardMonthController.text.split("/")[0],
                            cardExpiryYear:
                                "20${cardMonthController.text.split("/")[1]}",
                            cardCvv: cardCvvController.text),
                        amount: (widget.params.amount! * 100).toInt(),
                        callbackUrl:
                            "${PhonpePaymentGateway.instance.phonePeConfig.callBackUrl}?${maptoConvertUri.query}",
                        merchantTransactionId:
                            widget.params.merchantTransactionId,
                        merchantUserId: widget.params.merchantUserId,
                        mobileNumber: widget.params.mobileNumber,
                        merchantId: PhonpePaymentGateway
                            .instance.phonePeConfig.merchanId,
                        salt:
                            PhonpePaymentGateway.instance.phonePeConfig.saltKey,
                        saltIndex: PhonpePaymentGateway
                            .instance.phonePeConfig.saltIndex!
                            .toString()));
                if (data.status == "SUCCESS") {
                  PhonpePaymentGateway.instance.successPayment(data);
                  back();
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
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: const Text("Make Payment")),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != newText.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
