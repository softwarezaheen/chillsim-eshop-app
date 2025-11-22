package com.BaseFlutter.BaseFlutter.managers

import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.euicc.DownloadableSubscription
import android.telephony.euicc.EuiccManager
import android.util.Log
import androidx.core.content.ContextCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@SuppressLint("MissingPermission")
class ESIMManager(private val activity: Activity) {

    companion object {
        private const val TAG = "ESIMManager"
        const val REQUEST_CODE_ESIM_INSTALL = 1001
        private const val ACTION_PROVISION_EMBEDDED_SUBSCRIPTION =
            "android.service.euicc.action.PROVISION_EMBEDDED_SUBSCRIPTION"
    }

    private val actionDownloadSubscription: String
        get() = "${activity.packageName}.DOWNLOAD_SUBSCRIPTION"

    private val pendingIntentFlags: Int
        get() {
            var flags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                flags = flags or PendingIntent.FLAG_MUTABLE
            }
            return flags
        }

    private val euIccManager: EuiccManager? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            activity.getSystemService(Context.EUICC_SERVICE) as? EuiccManager
        } else {
            null
        }

    private var simpleDialog: AlertDialog? = null
    private var currentReceiver: BroadcastReceiver? = null
    private var pendingCallbackIntent: PendingIntent? = null
    private var lastActivationCode: String? = null

    fun installESIM(activationCode: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            showLoader("eSIM installation requires Android 9 or higher", "Ok")
            return
        }

        if (euIccManager?.isEnabled != true) {
            showLoader("eSIM functionality is disabled on this device", "Ok")
            return
        }

        val cleanedCode = sanitizeActivationCode(activationCode)
        lastActivationCode = cleanedCode
        Log.d(TAG, "=== Starting eSIM Installation ===")
        Log.d(TAG, "Activation code: $cleanedCode")

        try {
            Log.d(TAG, "eUICC OS Version: ${euIccManager?.euiccInfo?.osVersion}")
        } catch (e: Exception) {
            Log.w(TAG, "Unable to read eUICC info: ${e.message}")
        }

        registerReceiver()

        val callbackIntent = PendingIntent.getBroadcast(
            activity,
            0,
            Intent(actionDownloadSubscription).setPackage(activity.packageName),
            pendingIntentFlags
        )
        pendingCallbackIntent = callbackIntent

        try {
            val subscription = DownloadableSubscription.forActivationCode(cleanedCode)
            euIccManager?.downloadSubscription(subscription, true, callbackIntent)
                ?: run {
                    showLoader("Unable to access eSIM manager", "Ok")
                    safeUnregisterReceiver()
                }
        } catch (e: IllegalArgumentException) {
            Log.e(TAG, "Invalid activation code", e)
            showLoader("Invalid activation code format", "Ok")
            safeUnregisterReceiver()
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initiate eSIM download", e)
            showLoader("Failed to initiate eSIM installation", "Ok")
            safeUnregisterReceiver()
        }
    }

    private fun registerReceiver() {
        if (currentReceiver != null) {
            return
        }

        currentReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action != actionDownloadSubscription) {
                    return
                }

                val resultCode = resultCode
                val detailedCode = intent.getIntExtra(
                    EuiccManager.EXTRA_EMBEDDED_SUBSCRIPTION_DETAILED_CODE,
                    -1
                )
                val operationCode = intent.getIntExtra(
                    EuiccManager.EXTRA_EMBEDDED_SUBSCRIPTION_OPERATION_CODE,
                    -1
                )
                val errorCode = intent.getIntExtra(
                    EuiccManager.EXTRA_EMBEDDED_SUBSCRIPTION_ERROR_CODE,
                    -1
                )

                Log.d(TAG, "Broadcast received - resultCode=$resultCode")
                Log.d(TAG, "  detailedCode=$detailedCode")
                Log.d(TAG, "  operationCode=$operationCode")
                Log.d(TAG, "  errorCode=$errorCode")

                when (resultCode) {
                    0 -> {
                        CoroutineScope(Dispatchers.Main).launch {
                            showLoader("eSIM installed successfully", "Ok")
                            safeUnregisterReceiver()
                        }
                    }

                    1 -> {
                        handleResolvableError(intent)
                    }

                    else -> {
                        CoroutineScope(Dispatchers.Main).launch {
                            val friendlyMessage = mapErrorToMessage(errorCode)
                            val manualMessage = buildManualInstallMessage(friendlyMessage)
                            showLoader(manualMessage, "Ok")
                            safeUnregisterReceiver()
                            fallbackToManualInstall()
                        }
                    }
                }
            }
        }

        currentReceiver?.let {
            ContextCompat.registerReceiver(
                activity,
                it,
                IntentFilter(actionDownloadSubscription),
                ContextCompat.RECEIVER_EXPORTED
            )
        }
    }

    private fun handleResolvableError(resultIntent: Intent) {
        Log.w(TAG, "eSIM installation requires user confirmation")
        val callbackIntent = pendingCallbackIntent
        if (callbackIntent == null) {
            Log.e(TAG, "Missing callback intent for resolution flow")
            showLoader("Unable to continue installation. Please retry.", "Ok")
            safeUnregisterReceiver()
            return
        }
        CoroutineScope(Dispatchers.Main).launch {
            try {
                showLoader(
                    "Downloading profile… Please confirm the installation in the system dialog.",
                    "Ok"
                )
                euIccManager?.startResolutionActivity(
                    activity,
                    REQUEST_CODE_ESIM_INSTALL,
                    resultIntent,
                    callbackIntent
                )
                Log.d(TAG, "startResolutionActivity invoked")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start resolution activity", e)
                val manualMessage = buildManualInstallMessage(
                    "Unable to open the eSIM confirmation dialog."
                )
                showLoader(manualMessage, "Ok")
                safeUnregisterReceiver()
                fallbackToManualInstall()
            }
        }
    }

    private fun openEsimSettingsFallback(activationCode: String? = null) {
        try {
            val settingsIntent = Intent(Settings.ACTION_MANAGE_ALL_SIM_PROFILES_SETTINGS)
            settingsIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            activity.startActivity(settingsIntent)
            activationCode?.let {
                Log.d(TAG, "Opened eSIM settings for manual entry with code: $it")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Could not open eSIM settings: ${e.message}")
        }
    }

    private fun buildManualInstallMessage(baseMessage: String): String {
        val code = lastActivationCode
        return buildString {
            append(baseMessage)
            append("\n\nIf the installer does not appear, open Settings > Connections > SIM manager > Add eSIM > Use activation code.")
            if (!code.isNullOrBlank()) {
                append("\n\nActivation code:\n")
                append(code)
            }
        }
    }

    private fun fallbackToManualInstall() {
        val code = lastActivationCode
        if (!code.isNullOrBlank()) {
            if (trySamsungIntents(code)) {
                return
            }
            if (tryGenericLpaIntent(code)) {
                return
            }
        }
        openEsimSettingsFallback(code)
    }

    private fun trySamsungIntents(lpa: String): Boolean {
        val attempts = listOf(
            Pair("com.samsung.android.qrinstaller.ACTION_QR_SCAN", "com.samsung.android.qrinstaller"),
            Pair("com.samsung.android.lpa.ui.ACTION_START_CARRIER_ACTIVATION", "com.samsung.android.lpa")
        )

        for ((action, packageName) in attempts) {
            try {
                val intent = Intent(action).apply {
                    data = Uri.parse(lpa)
                    setPackage(packageName)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    putExtra("LPA_STRING", lpa)
                    putExtra("ACTIVATION_CODE", lpa)
                    putExtra("android.telephony.euicc.extra.ACTIVATION_CODE", lpa)
                }
                val handler = intent.resolveActivity(activity.packageManager)
                if (handler != null) {
                    Log.d(TAG, "Launching Samsung intent $action via ${handler.packageName}")
                    activity.startActivity(intent)
                    return true
                }
            } catch (e: Exception) {
                Log.w(TAG, "Samsung intent $action failed: ${e.message}")
            }
        }
        return false
    }

    private fun tryGenericLpaIntent(lpa: String): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(lpa)).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val handler = intent.resolveActivity(activity.packageManager)
            if (handler != null) {
                Log.d(TAG, "Launching generic LPA intent via ${handler.packageName}")
                activity.startActivity(intent)
                true
            } else {
                Log.d(TAG, "No handler for generic LPA ACTION_VIEW")
                false
            }
        } catch (e: Exception) {
            Log.w(TAG, "Generic LPA intent failed: ${e.message}")
            false
        }
    }

    private fun sanitizeActivationCode(rawCode: String): String {
        val trimmed = rawCode.trim()
        if (trimmed.startsWith("LPA:", ignoreCase = true)) {
            return trimmed
        }
        return "LPA:1${'$'}${trimmed}"
    }

    private fun mapErrorToMessage(errorCode: Int): String {
        return when (errorCode) {
            10004 -> "Not enough space on the eSIM chip. Please remove an old profile and try again."
            10003 -> "This device cannot install the selected eSIM profile."
            10009 -> "Failed to install the eSIM profile. Please retry."
            10014 -> "Connection problem while talking to the eSIM server. Please check your internet connection."
            else -> "Installation failed. Please retry or install from Settings."
        }
    }

    private fun safeUnregisterReceiver() {
        try {
            currentReceiver?.let {
                activity.unregisterReceiver(it)
            }
        } catch (e: IllegalArgumentException) {
            Log.d(TAG, "Receiver already unregistered")
        } finally {
            currentReceiver = null
            pendingCallbackIntent = null
        }
    }

    private fun showSimpleDialog(message: String, buttonText: String) {
        simpleDialog = AlertDialog
            .Builder(activity, android.R.style.Theme_Material_Light_Dialog)
            .setTitle("eSIM")
            .setMessage(message)
            .setPositiveButton(buttonText) { _, _ -> hideLoader() }
            .create()

        simpleDialog?.apply {
            setCancelable(false)
            setCanceledOnTouchOutside(false)
            setOnShowListener {
                getButton(AlertDialog.BUTTON_POSITIVE)?.setTextColor(Color.BLACK)
            }
            show()
        }
    }

    private fun showLoader(message: String, buttonText: String) {
        CoroutineScope(Dispatchers.Main).launch {
            hideLoader()
            showSimpleDialog(message, buttonText)
        }
    }

    private fun hideLoader() {
        if (simpleDialog?.isShowing == true) {
            simpleDialog?.dismiss()
        }
    }
}