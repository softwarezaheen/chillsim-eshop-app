package com.BaseFlutter.BaseFlutter

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import androidx.core.net.toUri


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.luxe.esim/flutter_to_native"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openSimProfilesSettings" -> {
                    openSimProfilesSettings(result)
                }

                "openEsimSetup" -> {
                    openEsimSetup(result, call);
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun openSimProfilesSettings(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) { // Android 9.0 (API 28) or higher
                val intent = Intent(Settings.ACTION_MANAGE_ALL_SIM_PROFILES_SETTINGS)
                startActivity(intent)
                result.success(true)
            } else {
                // For older versions, we can try to open the general network settings
                val intent = Intent(Settings.ACTION_NETWORK_OPERATOR_SETTINGS)
                startActivity(intent)
                result.success(true)
            }
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Could not open SIM profiles settings: ${e.message}", null)
        }
    }


    private fun openEsimSetup(result: MethodChannel.Result, call: MethodCall) {
        val cardData = call.argument<String>("cardData")
        if (!cardData.isNullOrEmpty()) {
            try {
                // check if the device is running android 15 or higher
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                    val intent = Intent(Intent.ACTION_VIEW).apply {
                        data = cardData.toUri()
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.success(false)
                }
            } catch (e: Exception) {
            result.error("UNAVAILABLE", "Could not install eSim: ${e.message}", null)
            }
        } else {
            result.error("INVALID_ARGUMENT", "Card data is required", null)
        }


    }

}
