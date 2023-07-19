class ParamsPayment {
  String? mobileNumber;
  double? amount;
  String? merchantUserId;
  String? merchantTransactionId;
  Map<String, dynamic>? notes;

  ParamsPayment(
      {this.mobileNumber,
      this.amount,
      this.merchantUserId,
      this.merchantTransactionId,
      this.notes});

  ParamsPayment.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    amount = json['amount'];
    merchantUserId = json['merchantUserId'];
    merchantTransactionId = json['merchantTransactionId'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['amount'] = amount;
    data['merchantUserId'] = merchantUserId;
    data['merchantTransactionId'] = merchantTransactionId;
    data['notes'] = notes;
    return data;
  }
}
