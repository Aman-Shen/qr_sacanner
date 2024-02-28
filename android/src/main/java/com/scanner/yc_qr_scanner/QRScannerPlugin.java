package com.scanner.qr_scanner;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.scanner.qr_scanner.zxing.CaptureActivity;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** QrScannerPlugin */
public class QRScannerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;
  private  Result result = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "qr_scanner");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);

    }else if(call.method.equals("scannerCodeResult")){
      this.result = result;
      Intent intent=new Intent(activity, CaptureActivity.class);

      activity.startActivityForResult(intent,1001);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @RequiresApi(api = Build.VERSION_CODES.Q)
  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

    activity = binding.getActivity();
    binding.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if(requestCode==1001){
          if(resultCode== Activity.RESULT_OK){
            String strResult = data.getStringExtra(CaptureActivity.KEY_DATA);
            if(result != null){
              result.success(strResult);
            }
          }else if(resultCode== Activity.RESULT_CANCELED){
            if(result != null){
              result.success(null);
            }
          }

          result = null;
        }

        return false;
      }
    });


//    activity.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks(){
//
//      @Override
//      public void onActivityPreCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
//
//      }
//
//      @Override
//      public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
//
//      }
//
//      @Override
//      public void onActivityPostCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
//
//      }
//
//      @Override
//      public void onActivityPreStarted(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityStarted(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPostStarted(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPreResumed(@NonNull Activity activity) {
//
//
//
//      }
//
//      @Override
//      public void onActivityResumed(@NonNull Activity activity) {
//
//        if(result != null){
//          result.success(null);
//        }
//        result = null;
//      }
//
//      @Override
//      public void onActivityPostResumed(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPrePaused(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPaused(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPostPaused(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPreStopped(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityStopped(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPostStopped(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPreSaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
//
//      }
//
//      @Override
//      public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
//
//      }
//
//      @Override
//      public void onActivityPostSaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
//
//      }
//
//      @Override
//      public void onActivityPreDestroyed(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityDestroyed(@NonNull Activity activity) {
//
//      }
//
//      @Override
//      public void onActivityPostDestroyed(@NonNull Activity activity) {
//
//      }
//    });

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
