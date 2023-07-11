package com.phonepe.simulator.test;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.phonepe.intent.sdk.api.PhonePe;
public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//       PhonePe.init(this);
    }

      private static final String CHANNEL = "samples.flutter.dev/battery";
//
//  @Override
//  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//  super.configureFlutterEngine(flutterEngine);
//    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//        .setMethodCallHandler(
//          (call, result) -> {
//
//            // This method is invoked on the main thread.
//            // TODO
//          }
//        );
//  }
}
