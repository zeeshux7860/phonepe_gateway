class PaymentWithCardModel {
  String? code;
  String? merchantId;
  String? transactionId;
  String? amount;
  String? providerReferenceId;
  String? param1;
  String? param2;
  String? param3;
  String? param4;
  String? param5;
  String? param6;
  String? param7;
  String? param8;
  String? param9;
  String? param10;
  String? param11;
  String? param12;
  String? param13;
  String? param14;
  String? param15;
  String? param16;
  String? param17;
  String? param18;
  String? param19;
  String? param20;
  String? checksum;

  PaymentWithCardModel(
      {this.code,
      this.merchantId,
      this.transactionId,
      this.amount,
      this.providerReferenceId,
      this.param1,
      this.param2,
      this.param3,
      this.param4,
      this.param5,
      this.param6,
      this.param7,
      this.param8,
      this.param9,
      this.param10,
      this.param11,
      this.param12,
      this.param13,
      this.param14,
      this.param15,
      this.param16,
      this.param17,
      this.param18,
      this.param19,
      this.param20,
      this.checksum});

  PaymentWithCardModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    merchantId = json['merchantId'];
    transactionId = json['transactionId'];
    amount = json['amount'];
    providerReferenceId = json['providerReferenceId'];
    param1 = json['param1'];
    param2 = json['param2'];
    param3 = json['param3'];
    param4 = json['param4'];
    param5 = json['param5'];
    param6 = json['param6'];
    param7 = json['param7'];
    param8 = json['param8'];
    param9 = json['param9'];
    param10 = json['param10'];
    param11 = json['param11'];
    param12 = json['param12'];
    param13 = json['param13'];
    param14 = json['param14'];
    param15 = json['param15'];
    param16 = json['param16'];
    param17 = json['param17'];
    param18 = json['param18'];
    param19 = json['param19'];
    param20 = json['param20'];
    checksum = json['checksum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['merchantId'] = merchantId;
    data['transactionId'] = transactionId;
    data['amount'] = amount;
    data['providerReferenceId'] = providerReferenceId;
    data['param1'] = param1;
    data['param2'] = param2;
    data['param3'] = param3;
    data['param4'] = param4;
    data['param5'] = param5;
    data['param6'] = param6;
    data['param7'] = param7;
    data['param8'] = param8;
    data['param9'] = param9;
    data['param10'] = param10;
    data['param11'] = param11;
    data['param12'] = param12;
    data['param13'] = param13;
    data['param14'] = param14;
    data['param15'] = param15;
    data['param16'] = param16;
    data['param17'] = param17;
    data['param18'] = param18;
    data['param19'] = param19;
    data['param20'] = param20;
    data['checksum'] = checksum;
    return data;
  }
}
