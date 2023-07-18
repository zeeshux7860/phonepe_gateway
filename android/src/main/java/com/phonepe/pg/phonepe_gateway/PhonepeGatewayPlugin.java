package com.phonepe.pg.phonepe_gateway;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.phonepe.intent.sdk.api.PhonePe;
import com.phonepe.intent.sdk.api.PhonePeInitException;
import com.phonepe.intent.sdk.api.UPIApplicationInfo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** PhonepeGatewayPlugin */

public class PhonepeGatewayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener,  PreferenceManager.OnActivityResultListener {

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
    private Context context;
    private Activity activity;

    private static final int B2B_PG_REQUEST_CODE = 777;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

      context = flutterPluginBinding.getApplicationContext();
      PhonePe.init(this.context);
      channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "phonepe_gateway");
    channel.setMethodCallHandler(this);
  }

  String apiEndPoint = "/pg/v1/pay";
    private MethodChannel.Result pendingResult;


  @RequiresApi(api = Build.VERSION_CODES.O)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d("DEBUG", call.method);
      switch (call.method) {
          case "getPlatformVersion":
              System.out.print("Android " + Build.VERSION.RELEASE);
              result.success("Android " + Build.VERSION.RELEASE);

              break;
          case "getUpi":
              try {
                  List<UPIApplicationInfo> upiApps = PhonePe.getUpiApps();
                  JSONArray jsonArray = new JSONArray();
                  // Create a JSON object


                  // Add key-value pairs to the JSON object
//        jsonObject.put("name", "John Doe");
                  for (UPIApplicationInfo appInfo : upiApps) {
                      JSONObject jsonObject = new JSONObject();
                      jsonObject.put("packageName", appInfo.getPackageName());
                      jsonObject.put("applicationName", appInfo.getApplicationName());
                      jsonObject.put("version", appInfo.getVersion());
                      jsonArray.put(jsonObject);
                  }
                  // Create a final JSON object
                  JSONObject finalListOfUpi = new JSONObject();
                  finalListOfUpi.put("list_of_upi", jsonArray);
                  result.success(finalListOfUpi.toString());
              } catch (PhonePeInitException | JSONException exception) {
                  exception.printStackTrace();
              }
              break;
          case "payWIthUpi":
              try {
                  Log.d("DEBUG", call.argument("salt"));

                  HashMap<String, Object> data = new HashMap();
                  data.put("merchantTransactionId", call.argument("merchantTransactionId"));        //String. Mandatory
                  data.put("merchantId", "VOICECLUBONLINE");             //String. Mandatory
                  data.put("merchantUserId",call.argument("merchantUserId"));             //String. Conditional


//// merchantUserId - Mandatory if paymentInstrument.type is: PAY_PAGE, CARD, SAVED_CARD, TOKEN.
//// merchantUserId - Optional if paymentInstrument.type is: UPI_INTENT, UPI_COLLECT, UPI_QR.
                  data.put("amount", call.argument("amount"));                         //Long. Mandatory
                  data.put("mobileNumber", call.argument("mobileNumber"));          //String. Optional
                  data.put("callbackUrl", call.argument("callbackUrl"));    //String. Mandatory

                  HashMap<String, Object> mPaymentInstrument = new HashMap();
                  mPaymentInstrument.put("type", "UPI_INTENT");           // Intent flow. ENUM. Mandatory
                  mPaymentInstrument.put("targetApp", call.argument("packageName"));  //String. Mandatory
                  data.put("paymentInstrument", mPaymentInstrument);   //OBJECT. Mandatory

//        DeviceContext mDeviceContext = new DeviceContext();
                  HashMap<String, Object> mDeviceContext = new HashMap();
                  mDeviceContext.put("deviceOS", "ANDROID");          //
//        ENUM. Mandatory
                  data.put("deviceContext", mDeviceContext);   //OBJECT. Mandatory
                  Gson gson = new GsonBuilder().setPrettyPrinting().create();
                  String jsonOutput = gson.toJson(data);

//        String originalString = new Gson().toJson(data).toString();
                  String base64Body = Base64.getEncoder().encodeToString(jsonOutput.getBytes());
                  MessageDigest digest = MessageDigest.getInstance("SHA-256");
                  byte[] encodedhash = digest.digest(
                          (base64Body + apiEndPoint + call.argument("salt")).getBytes(StandardCharsets.UTF_8));

                  String checksum = bytesToHex(encodedhash) + "###" + call.argument("saltIndex");

                          String string_signature = PhonePe.getPackageSignature();
                  PhonePeService apiInstance = new PhonePeService();

                  Log.d("DEBUG", string_signature);
                  Log.d("DEBUG", checksum);
                  Log.d("DEBUG", base64Body);
                  JSONObject response = new  JSONObject();
                  response.put("status", true);
                  response.put("checksum", checksum);
                  response.put("base64Body", base64Body);
                  response.put("packageName", call.argument("packageName"));
                  result.success(response.toString());
                  //For SDK call below function
                         //APP_PACKAGE will be the package name of the App selected by the user.

// To Initiate Payment.


              } catch (NoSuchAlgorithmException exception) {

                  exception.printStackTrace();

              } catch (JSONException e) {
                  throw new RuntimeException(e);
              }
              break;
          case "payWIthIntent": {
              Log.d("DEBUG",call.arguments().toString());
              Intent intent = new Intent();
              intent.setAction(Intent.ACTION_VIEW);
              intent.setData( Uri.parse(call.argument("intentUrl")));    //PhonePe Intent redirectUrl from the response.
              intent.setPackage(call.argument("packageName"));
              pendingResult = result;
              activity.startActivityForResult(intent,B2B_PG_REQUEST_CODE);
              Log.d("DEBUG", "ok");

//              activity.
//                activity.getIntent().
          }
          break;
          default:
              result.notImplemented();
              break;
      }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      context = null;
    channel.setMethodCallHandler(null);
  }

    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
//        pendingResult.success("OK");
        // Handle the result of the activity here
Log.d("DEBUG", String.valueOf(resultCode));
Log.d("DEBUG", String.valueOf(resultCode));
// null check for the intent
        if (data != null) {
            // do your stuff here
            Log.d("DEBUG", String.valueOf(pendingResult == null));
            // has extra
            if (data != null && data.getExtras() != null) {
                Bundle extras = data.getExtras();
//Log.d("DEBUG", convertBundleToJson(extras));
pendingResult.success(convertBundleToJson(extras));
                // You can also iterate over the keys if you need to perform specific operations

            }

        }
        if (requestCode == B2B_PG_REQUEST_CODE) {
            // Process the result
            // Handle success
            // Handle failure
            return true; // Return true to indicate that the result was handled
        }else {
            Log.d("DEBUG", "Test");
        }
        return true; // Return false if the result is not related to this plugin
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }




    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }


    public static String convertBundleToJson(Bundle bundle) {
        JSONObject jsonObject = new JSONObject();
        try {
            for (String key : bundle.keySet()) {
                Object value = bundle.get(key);
                if (value instanceof Boolean) {
                    jsonObject.put(key, (Boolean) value);
                } else if (value instanceof Integer) {
                    jsonObject.put(key, (Integer) value);
                } else if (value instanceof Long) {
                    jsonObject.put(key, (Long) value);
                } else if (value instanceof Double) {
                    jsonObject.put(key, (Double) value);
                } else if (value instanceof String) {
                    jsonObject.put(key, (String) value);
                } else if (value instanceof Bundle) {
                    // If the value is a nested Bundle, convert it to JSONObject recursively
                    jsonObject.put(key, new JSONObject(convertBundleToJson((Bundle) value)));
                }
                // You can add more conditions based on your specific needs
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

}
