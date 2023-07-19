class CardParams {
  CardDetails? cardDetails;
  String? merchantTransactionId;
  String? merchantUserId;
  String? merchantId;
  int? amount;
  String? mobileNumber;
  String? callbackUrl;
  String? salt;
  String? saltIndex;

  CardParams(
      {this.cardDetails,
      this.merchantTransactionId,
      this.merchantUserId,
      this.merchantId,
      this.amount,
      this.mobileNumber,
      this.callbackUrl,
      this.salt,
      this.saltIndex});

  CardParams.fromJson(Map<String, dynamic> json) {
    cardDetails = json['card_details'] != null
        ? CardDetails.fromJson(json['card_details'])
        : null;
    merchantTransactionId = json['merchantTransactionId'];
    merchantUserId = json['merchantUserId'];
    merchantId = json['merchantId'];
    amount = json['amount'];
    mobileNumber = json['mobileNumber'];
    callbackUrl = json['callbackUrl'];
    salt = json['salt'];
    saltIndex = json['saltIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cardDetails != null) {
      data['card_details'] = cardDetails!.toJson();
    }
    data['merchantTransactionId'] = merchantTransactionId;
    data['merchantUserId'] = merchantUserId;
    data['merchantId'] = merchantId;
    data['amount'] = amount;
    data['mobileNumber'] = mobileNumber;
    data['callbackUrl'] = callbackUrl;
    data['salt'] = salt;
    data['saltIndex'] = saltIndex;
    return data;
  }
}

class CardDetails {
  String? cardNumber;
  String? cardExpiryMonth;
  String? cardExpiryYear;
  String? cardCvv;
  String? cardHolderName;

  CardDetails(
      {this.cardNumber,
      this.cardExpiryMonth,
      this.cardExpiryYear,
      this.cardCvv,
      this.cardHolderName});

  CardDetails.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    cardExpiryMonth = json['cardExpiryMonth'];
    cardExpiryYear = json['cardExpiryYear'];
    cardCvv = json['cardCvv'];
    cardHolderName = json['cardHolderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardNumber'] = cardNumber;
    data['cardExpiryMonth'] = cardExpiryMonth;
    data['cardExpiryYear'] = cardExpiryYear;
    data['cardCvv'] = cardCvv;
    data['cardHolderName'] = cardHolderName;
    return data;
  }
}
