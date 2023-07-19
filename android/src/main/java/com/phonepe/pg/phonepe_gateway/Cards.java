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
//           data.put("redirectUrl", "https://mykewlapp.com/redirect");
           data.put("redirectMode", "POST");
           data.put("callbackUrl", call.argument("callbackUrl"));

           CardsPaymentInstruments mPaymentInstrument = new CardsPaymentInstruments();
           mPaymentInstrument.setType("CARD"); // Card Flow
           mPaymentInstrument.setAuthMode("3DS");

           ExpiryDetails mExpiryDetails = new ExpiryDetails();
           mExpiryDetails.setMonth(call.argument("cardExpiryMonth"));
           mExpiryDetails.setYear(call.argument("cardExpiryYear"));
           // encrypted
           // Generate RSA key pair with 4096-bit length
           KeyPair keyPair = generateRSAKeyPair(4096);
           // Example plaintext data to encrypt
           String plaintext = call.argument("cardNumber");

           // Encrypt the plaintext using the RSA public key
           byte[] encryptedData = RSAEncrypt(plaintext, keyPair.getPublic());
           NewCardDetails mNewCardDetails = new NewCardDetails();
           mNewCardDetails.setEncryptedCardNumber(plaintext);
           mNewCardDetails.setCardHolderName(call.argument("cardHolderName"));
           mNewCardDetails.setEncryptedKeyId(4096);
           mNewCardDetails.setExpiry(mExpiryDetails);
           mNewCardDetails.setCvv(bytesToHex(RSAEncrypt(call.argument("cardCvv"), keyPair.getPublic())));

           mPaymentInstrument.setCardDetails(mNewCardDetails);
           data.put("paymentInstrument", mPaymentInstrument);
           Gson gson = new GsonBuilder().setPrettyPrinting().create();
           String jsonOutput = gson.toJson(data);
           // Printing the HashMap (optional)
           Log.d("DEBUG",jsonOutput);

//
//           Log.d("DEBUG","Decrypted Data: " + keyPair.getPublic());
//
//           Log.d("DEBUG","Encrypted Data: " + bytesToHex(encryptedData));
//
//           // Decrypt the encrypted data using the RSA private key
//           String decryptedData = RSADecrypt(encryptedData, keyPair.getPrivate());
//           Log.d("DEBUG","Decrypted Data: " + decryptedData);
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

    public static KeyPair generateRSAKeyPair(int keyLength) throws NoSuchAlgorithmException {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(keyLength);
        return keyPairGenerator.generateKeyPair();
    }

    public static byte[] RSAEncrypt(String plaintext, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return cipher.doFinal(plaintext.getBytes());
    }

    public static String RSADecrypt(byte[] encryptedData, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedData = cipher.doFinal(encryptedData);
        return new String(decryptedData);
    }

    public static String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02X", b));
        }
        return result.toString();
    }
}
class CardsPaymentInstruments {
    private String type;
    private String authMode;
    private NewCardDetails cardDetails;

    // Constructors
    public CardsPaymentInstruments() {
    }

    public CardsPaymentInstruments(String type, String authMode, NewCardDetails cardDetails) {
        this.type = type;
        this.authMode = authMode;
        this.cardDetails = cardDetails;
    }

    // Getters and setters
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAuthMode() {
        return authMode;
    }

    public void setAuthMode(String authMode) {
        this.authMode = authMode;
    }

    public NewCardDetails getCardDetails() {
        return cardDetails;
    }

    public void setCardDetails(NewCardDetails cardDetails) {
        this.cardDetails = cardDetails;
    }


}

class ExpiryDetails {
    private String month;
    private String year;

    // Constructors
    public ExpiryDetails() {
    }

    public ExpiryDetails(String month, String year) {
        this.month = month;
        this.year = year;
    }

    // Getters and setters
    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

}

class NewCardDetails {
    private String encryptedCardNumber;
    private String cardHolderName;
    private int encryptionKeyId;
    private ExpiryDetails expiry;
    private String encryptedCvv;

    // Constructors
    public NewCardDetails() {
    }

    public NewCardDetails(String encryptedCardNumber, String cardHolderName, int encryptionKeyId, ExpiryDetails expiry, String cvv) {
        this.encryptedCardNumber = encryptedCardNumber;
        this.cardHolderName = cardHolderName;
        this.encryptionKeyId = encryptionKeyId;
        this.expiry = expiry;
        this.encryptedCvv = cvv;
    }

    // Getters and setters
    public String getEncryptedCardNumber() {
        return encryptedCardNumber;
    }

    public void setEncryptedCardNumber(String encryptedCardNumber) {
        this.encryptedCardNumber = encryptedCardNumber;
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public int getEncryptedKeyId() {
        return encryptionKeyId;
    }

    public void setEncryptedKeyId(int encryptedKeyId) {
        this.encryptionKeyId = encryptedKeyId;
    }

    public ExpiryDetails getExpiry() {
        return expiry;
    }

    public void setExpiry(ExpiryDetails expiry) {
        this.expiry = expiry;
    }

    public String getCvv() {
        return encryptedCvv;
    }

    public void setCvv(String cvv) {
        this.encryptedCvv = cvv;
    }


}
