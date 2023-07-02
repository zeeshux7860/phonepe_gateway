import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phonepe_gateway/phonepe_gateway_method_channel.dart';

void main() {
  MethodChannelPhonepeGateway platform = MethodChannelPhonepeGateway();
  const MethodChannel channel = MethodChannel('phonepe_gateway');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
