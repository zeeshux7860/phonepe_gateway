import 'dart:async';

import 'package:phonepe_gateway/model/payment_complete.dart';
import 'package:phonepe_gateway/model/phonepe_config.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/phonepe_gateway.dart';

// override this class to get callback
class PhonpePaymentGateway {
  // callBackUrl, saltKey, saltIndex, AppName
  late PhonePeConfig phonePeConfig;

  /// init method
  ///  [config] is required to get callback from phonepe gateway app to your app after payment is done or failed or cancelled by user or by phonepe gateway app itself due to some error or any other reason
  void init({required PhonePeConfig config}) {
    phonePeConfig = config;
  }

  // instance of this class
  static final PhonpePaymentGateway _instance = PhonpePaymentGateway();

  // getter of this class
  /// [instance] is used to get instance of this class
  static PhonpePaymentGateway get instance => _instance;

  // create stream _controllerCancelled
  /// [_controllerCancelled] is used to get callback from phonepe gateway app to your app after payment is cancelled by user or by phonepe gateway app itself due to some error or any other reason
  /// [PaymentMethod] is the model class which contains status and message
  final StreamController<PaymentMethod> _controllerCancelled =
      StreamController<PaymentMethod>.broadcast();

  // getter of _controllerCancelled controller
  ///  [handlerCancelled] is used to get callback from phonepe gateway app to your app after payment is cancelled by user or by phonepe gateway app itself due to some error or any other reason
  ///  [PaymentMethod] is the model class which contains status and message
  /// [status] is the status of payment
  /// [message] is the message of payment
  /// [status] can be "Cancelled" or "Failed"
  /// [message] can be "User cancelled the payment" or "Something went to wrongs"
  ///
  StreamSubscription<PaymentMethod> Function(void Function(PaymentMethod)?,
          {bool? cancelOnError, void Function()? onDone, Function? onError})
      get handlerCancelled => _controllerCancelled.stream.listen;

  // set
  void cancelPayment(String message) {
    var returnData = PaymentMethod(
      status: "Cancelled",
      message: message,
    );
    _controllerCancelled.sink.add(returnData);
  }

  // -------------------------------------------------------------------------------------------------------

  /// [_controllerFailed] is used to get callback from phonepe gateway app to your app after payment is failed by user or by phonepe gateway app itself due to some error or any other reason
  final StreamController<PaymentMethod> _controllerFailed =
      StreamController<PaymentMethod>.broadcast();

  // getter of _controllerFailed controller
  StreamSubscription<PaymentMethod> Function(void Function(PaymentMethod)?,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) get handlerFailed => _controllerFailed.stream.listen;

  // set
  void failedPayment(PaymentMethod data) {
    _controllerFailed.sink.add(data);
  }

  /// [_controllerFailed] is used to get callback from phonepe gateway app to your app after payment is failed by user or by phonepe gateway app itself due to some error or any other reason
  final StreamController<PaymentMethod> _controllerSuccess =
      StreamController<PaymentMethod>.broadcast();

  // getter of _controllerFailed controller
  StreamSubscription<PaymentMethod> Function(void Function(PaymentMethod)?,
          {bool? cancelOnError, void Function()? onDone, Function? onError})
      get handlerSuccess => _controllerSuccess.stream.listen;

  // set
  void successPayment(PaymentMethod data) {
    _controllerSuccess.sink.add(data);
  }

  // dispose stream controller
  void dispose() {
    _controllerCancelled.close();
    _controllerFailed.close();
    _controllerSuccess.close();
  }

  /// [initPayment] is used to init payment
  /// [context] is the context of the widget
  /// [params] is the model class which contains all the required parameters to init payment
  /// [params] is required to init payment
  void initPayment(context, {required ParamsPayment params}) {
    PhonepeGateway().init(context, params);
  }
}
