class CardParams {
  String? merchantTransactionId;
  String? merchantUserId;
  String? merchantId;
  int? amount;
  String? mobileNumber;
  String? callbackUrl;
  String? salt;
  String? saltIndex;
  String? redirectUrl;
  String? redirectMode;

  CardParams(
      {this.merchantTransactionId,
      this.merchantUserId,
      this.merchantId,
      this.amount,
      this.mobileNumber,
      this.callbackUrl,
      this.salt,
      this.saltIndex,
      this.redirectUrl,
      this.redirectMode});

  CardParams.fromJson(Map<String, dynamic> json) {
    merchantTransactionId = json['merchantTransactionId'];
    merchantUserId = json['merchantUserId'];
    merchantId = json['merchantId'];
    amount = json['amount'];
    mobileNumber = json['mobileNumber'];
    callbackUrl = json['callbackUrl'];
    salt = json['salt'];
    saltIndex = json['saltIndex'];
    redirectUrl = json['redirectUrl'];
    redirectMode = json['redirectMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantTransactionId'] = merchantTransactionId;
    data['merchantUserId'] = merchantUserId;
    data['merchantId'] = merchantId;
    data['amount'] = amount;
    data['mobileNumber'] = mobileNumber;
    data['callbackUrl'] = callbackUrl;
    data['salt'] = salt;
    data['saltIndex'] = saltIndex;
    data['redirectUrl'] = redirectUrl;
    data['redirectMode'] = redirectMode;
    return data;
  }
}
