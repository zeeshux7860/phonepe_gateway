import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:phonepe_gateway/model/upi.dart';
import 'package:phonepe_gateway/phonepe_gateway.dart';
import 'package:shimmer/shimmer.dart';

class UpiWidget extends StatefulWidget {
  const UpiWidget({super.key});

  @override
  State<UpiWidget> createState() => _UpiWidgetState();
}

class _UpiWidgetState extends State<UpiWidget> {
  final _phonepeGatewayPlugin = PhonepeGateway();
  UPI? dsValue;
  @override
  void initState() {
    _phonepeGatewayPlugin.getUpi().then((value) {
      setState(() {
        dsValue = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dsValue == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[50]!,
            highlightColor: Colors.grey[200]!,
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('PhonePe'),
                  );
                },
              ),
            ),
          )
        : SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dsValue!.listOfUpi!.length,
              itemBuilder: (context, index) {
                var value = dsValue!.listOfUpi![index];

                return FutureBuilder(
                    future: getIcon(value.packageName!),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.all(10),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                 var data = await  _phonepeGatewayPlugin.payWIthUpi(
                                      upiParams: UpiParams(
                                          amount: 100,
                                          callbackUrl:
                                              "https://webhook.site/dede1e1a-70cc-43ee-ad22-1ee60d574c9d",
                                          merchantTransactionId:
                                              DateTime.now().microsecondsSinceEpoch.toString(),
                                          merchantUserId: "90223250",
                                          mobileNumber: "9088226981",
                                          packageName: value.packageName,
                                          salt:
                                              "a9e8cbaf-c914-48ec-80db-3b9f19e745f1",
                                          saltIndex: 1));
                                  print(data.status);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.memory(snapshot.data ?? Uint8List(0),
                                        height: 50, width: 50),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      value.applicationName!,
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    });
              },
            ),
          );
  }

  Future<Uint8List> getIcon(String packageName) async {
    var ds = await InstalledApps.getAppInfo(packageName);
    return ds.icon!;
  }
}
