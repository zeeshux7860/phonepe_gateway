import 'package:flutter/services.dart';

class UPI {
  List<ListOfUpi>? listOfUpi;

  UPI({this.listOfUpi});

  UPI.fromJson(Map<String, dynamic> json) {
    if (json['list_of_upi'] != null) {
      listOfUpi = <ListOfUpi>[];
      json['list_of_upi'].forEach((v) {
        listOfUpi!.add(ListOfUpi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listOfUpi != null) {
      data['list_of_upi'] = listOfUpi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListOfUpi {
  String? packageName;
  String? applicationName;
  int? version;
  Uint8List? icon;

  ListOfUpi({this.packageName, this.applicationName, this.version, this.icon});

  ListOfUpi.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    applicationName = json['applicationName'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageName'] = packageName;
    data['applicationName'] = applicationName;
    data['version'] = version;
    data['icon'] = icon;
    return data;
  }
}

class UpiParams {
  String? packageName;
  String? merchantTransactionId;
  String? merchantUserId;
  String? merchantId;
  int? amount;
  String? mobileNumber;
  String? callbackUrl;
  String? salt;
  int? saltIndex;

  UpiParams(
      {this.packageName,
      this.merchantTransactionId,
      this.merchantUserId,
      this.merchantId,
      this.amount,
      this.mobileNumber,
      this.callbackUrl,
      this.salt,
      this.saltIndex});

  UpiParams.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
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
    data['packageName'] = packageName;
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
