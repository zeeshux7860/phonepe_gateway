import 'package:phonepe_gateway/model/upi.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'phonepe_gateway_method_channel.dart';

abstract class PhonepeGatewayPlatform extends PlatformInterface {
  /// Constructs a PhonepeGatewayPlatform.
  PhonepeGatewayPlatform() : super(token: _token);

  static final Object _token = Object();

  static PhonepeGatewayPlatform _instance = MethodChannelPhonepeGateway();

  /// The default instance of [PhonepeGatewayPlatform] to use.
  ///
  /// Defaults to [MethodChannelPhonepeGateway].
  static PhonepeGatewayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PhonepeGatewayPlatform] when
  /// they register themselves.
  static set instance(PhonepeGatewayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future getUpi() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future payWIthUpi({
    required UpiParams upiParams,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

    Future payWIthIntent({
    required String intentUrl,
    String? packageName
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
