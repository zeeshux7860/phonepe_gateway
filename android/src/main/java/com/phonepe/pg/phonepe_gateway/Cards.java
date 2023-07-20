package com.phonepe.pg.phonepe_gateway;

import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Base64;
import java.util.HashMap;

import javax.crypto.Cipher;

import io.flutter.plugin.common.MethodCall;

public class Cards {

    public static JSONObject details(MethodCall call) {
        String apiEndPoint = "/pg/v1/pay";
       try {

           // Define the data HashMap
           HashMap<String, Object> data = new HashMap<>();

           // Populate the HashMap
           String txnId = "TXN" + call.argument("merchantTransactionId");
           String merchantId = call.argument("merchantId");

           data.put("merchantTransactionId", txnId);
           data.put("merchantId", merchantId);
           data.put("merchantUserId", call.argument("merchantUserId"));
           data.put("amount", call.argument("amount"));
           data.put("redirectUrl", call.argument("redirectUrl"));
           data.put("redirectMode", call.argument("redirectMode"));
           data.put("callbackUrl", call.argument("callbackUrl"));

           HashMap<String, Object> mPaymentInstrument =  new HashMap<>();
           mPaymentInstrument.put("type","PAY_PAGE"); // Card Flow


           data.put("paymentInstrument", mPaymentInstrument);
           Gson gson = new GsonBuilder().setPrettyPrinting().create();
           String jsonOutput = gson.toJson(data);
           // Printing the HashMap (optional)
           Log.d("DEBUG",jsonOutput);

           String base64Body = null;
           if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
               base64Body = Base64.getEncoder().encodeToString(jsonOutput.getBytes());
           }
           MessageDigest digest = MessageDigest.getInstance("SHA-256");
           byte[] encodedhash = digest.digest(
                   (base64Body + apiEndPoint + call.argument("salt")).getBytes(StandardCharsets.UTF_8));

           String checksum = bytesToHex(encodedhash) + "###" + 1;
           JSONObject response = new  JSONObject();
           response.put("status", true);
           response.put("checksum", checksum);
           response.put("base64Body", base64Body);
           return response;
       } catch (NoSuchAlgorithmException e) {
           throw new RuntimeException(e);
       } catch (Exception e) {
           throw new RuntimeException(e);
       }
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
}
