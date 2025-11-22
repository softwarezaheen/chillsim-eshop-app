package com.BaseFlutter.BaseFlutter

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.net.toUri
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.BaseFlutter.BaseFlutter.managers.ESIMManager

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "zaheen.esim.chillsim/flutter_to_native"
    private var esimManager: ESIMManager? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openSimProfilesSettings" -> openSimProfilesSettings(result)
                "openEsimSetup" -> openEsimSetup(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun openSimProfilesSettings(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val intent = Intent(Settings.ACTION_MANAGE_ALL_SIM_PROFILES_SETTINGS)
                startActivity(intent)
                result.success(true)
            } else {
                val intent = Intent(Settings.ACTION_NETWORK_OPERATOR_SETTINGS)
                startActivity(intent)
                result.success(true)
            }
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Could not open SIM profiles settings: ${e.message}", null)
        }
    }

    private fun openEsimSetup(call: MethodCall, result: MethodChannel.Result) {
        val rawCardData = call.argument<String>("cardData")
        val isShaExist = (call.argument<String>("isSHAExist") ?: "false").toBoolean()

        if (rawCardData.isNullOrEmpty()) {
            result.error("INVALID_ARGUMENT", "Card data is required", null)
            return
        }

        val normalizedUri = normalizeLpaUri(rawCardData)
        android.util.Log.d("eSIM", "Attempting to install eSIM with URI: $normalizedUri")

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                android.util.Log.d("eSIM", "Using ESIMManager for installation")
                if (esimManager == null) {
                    esimManager = ESIMManager(this)
                }
                esimManager?.installESIM(normalizedUri)
                result.success(true)
                return
            }

            if (isShaExist) {
                ESIMManager(this).installESIM(normalizedUri)
                result.success(true)
                return
            }

            // Android 15+ (official LPA auto-install)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                launchLpaInstaller(normalizedUri)
                result.success(true)
                return
            }

            // Samsung & Pixel fallback LPA (Android 10–14)
            if (launchOemLpa(normalizedUri)) {
                result.success(true)
                return
            }

            // Android 9–14 fallback (manual add)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                openEsimSettings()
                result.success(true)
                return
            }

            result.success(false)
        } catch (e: Exception) {
            result.error("INSTALL_ERROR", e.message, null)
        }
    }

    /** Normalize LPA format */
    private fun normalizeLpaUri(data: String): String {
        return if (data.startsWith("LPA:", ignoreCase = true)) data else "LPA:1\$$data"
    }

    /** Android 15+ official installer */
    private fun launchLpaInstaller(lpa: String) {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse(lpa)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
    }

    /** OEM LPAs: Samsung / Google Pixel */
    private fun launchOemLpa(lpa: String): Boolean {
        val packages = listOf(
            "com.samsung.android.lpa",
            "com.samsung.android.qrinstaller",
            "com.google.euiccpixel",
            "com.google.android.euicc"
        )

        for (pkg in packages) {
            try {
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    setPackage(pkg)
                    data = Uri.parse(lpa)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    return true
                }
            } catch (_: Exception) {}
        }
        return false
    }

    /** Manual fallback */
    private fun openEsimSettings() {
        val intent = Intent(Settings.ACTION_MANAGE_ALL_SIM_PROFILES_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == ESIMManager.REQUEST_CODE_ESIM_INSTALL) {
            android.util.Log.d(
                "eSIM",
                "onActivityResult: requestCode=$requestCode resultCode=$resultCode"
            )
        }
    }
}
