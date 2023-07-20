class PhonePeConfig {
  String? callBackUrl;
  String? baseUrl;
  String? saltKey;
  num? saltIndex;
  String? appName;
  String? merchanId;
  String? redirectUrl;

  PhonePeConfig(
      {this.callBackUrl,
      this.baseUrl,
      this.saltKey,
      this.saltIndex,
      this.appName,
      this.merchanId,
      this.redirectUrl});

  PhonePeConfig.fromJson(Map<String, dynamic> json) {
    callBackUrl = json['callBackUrl'];
    baseUrl = json['baseUrl'];
    saltKey = json['saltKey'];
    saltIndex = json['saltIndex'];
    appName = json['appName'];
    merchanId = json['merchanId'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callBackUrl'] = callBackUrl;
    data['baseUrl'] = baseUrl;
    data['saltKey'] = saltKey;
    data['saltIndex'] = saltIndex;
    data['appName'] = appName;
    data['merchanId'] = merchanId;
    data['redirectUrl'] = redirectUrl;
    return data;
  }
}
