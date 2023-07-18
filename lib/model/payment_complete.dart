class PaymentMethod {
  String? status;
  String? message;
  String? txnRef;
  String? approvalRefNo;
  String? response;
  String? txnId;
  String? responseCode;
  String? trtxnRef;

  PaymentMethod(
      {this.status,
      this.message,
      this.txnRef,
      this.approvalRefNo,
      this.response,
      this.txnId,
      this.responseCode,
      this.trtxnRef});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    txnRef = json['txnRef'];
    approvalRefNo = json['ApprovalRefNo'];
    response = json['response'];
    txnId = json['txnId'];
    responseCode = json['responseCode'];
    trtxnRef = json['TrtxnRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['txnRef'] = txnRef;
    data['ApprovalRefNo'] = approvalRefNo;
    data['response'] = response;
    data['txnId'] = txnId;
    data['responseCode'] = responseCode;
    data['TrtxnRef'] = trtxnRef;
    return data;
  }
}
