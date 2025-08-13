package com.BaseFlutter.BaseFlutter.managers

import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.euicc.DownloadableSubscription
import android.telephony.euicc.EuiccManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@SuppressLint("NewApi")
class ESIMManager(
    private val activity: Activity,
) {

    companion object {
        private const val TAG = "ESIMManager"
    }

    private val eSimSuccess = 0
    private val eSimFailed = 1
    private val actionDownloadSubscription get() = "${activity.packageName}.DOWNLOAD_SUBSCRIPTION"
    private val permissionInstallESIM
        get() =
            "${activity.packageName}.permission.WRITE_EMBEDDED_SUBSCRIPTIONS"
    private val lpaDeclaredPermission get() = "${activity.packageName}.lpa.permission.BROADCAST"
    private val permissionBroadcast get() = "${activity.packageName}.lpa.permission.BROADCAST"
    private var subscriptionManager: SubscriptionManager? = null
    var euIccManager: EuiccManager? = null
    private var simpleDialog: AlertDialog? = null
    private var currentReceiver: BroadcastReceiver? = null

    init {
        euIccManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            activity.getSystemService(Context.EUICC_SERVICE) as EuiccManager
        } else null
        subscriptionManager =
            activity.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as? SubscriptionManager
    }

    fun installESIM(activationCode: String) {
        if (isESIMSupported().not()) {
            showLoader(
                "eSIM not supported on this device",
                "Ok"
            )
            return
        }

        Log.d(TAG, "installShaeSim: activation code : $activationCode")
        lateinit var receiver: BroadcastReceiver

        val intent = Intent(actionDownloadSubscription).setPackage(activity.packageName)

        val callbackIntent = PendingIntent.getBroadcast(
            activity,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        CoroutineScope(Dispatchers.IO).launch {
            if (ContextCompat.checkSelfPermission(
                    activity,
                    permissionInstallESIM
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    activity,
                    arrayOf(permissionInstallESIM),
                    1
                )
            }

            if (ContextCompat.checkSelfPermission(
                    activity,
                    permissionBroadcast
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    activity,
                    arrayOf(permissionBroadcast),
                    1
                )
            }

            receiver = object : BroadcastReceiver() {
                @SuppressLint("SetTextI18n", "NewApi")
                override fun onReceive(context: Context, intent: Intent) {
                    try {
                        if (actionDownloadSubscription != intent.action) {
                            return
                        }

                        val resultIntent = intent

                        when (resultCode) {
                            eSimSuccess -> {
                                CoroutineScope(Dispatchers.Main).launch {
                                    showLoader(
                                        "eSIM installed successfully",
                                        "Ok"
                                    )
                                    safeUnregisterReceiver()
                                }
                            }

                            eSimFailed -> {
                                showLoader(
                                    "Downloading and Installing eSIM profile",
                                    "Continue in Background"
                                )
                                euIccManager?.startResolutionActivity(
                                    activity,
                                    0,
                                    resultIntent,
                                    callbackIntent
                                )
                            }

                            else -> {
                                CoroutineScope(Dispatchers.Main).launch {
                                    showLoader("Installation Failed", "Ok")
                                    safeUnregisterReceiver()
                                }
                            }
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Error in broadcast receiver", e)
                        CoroutineScope(Dispatchers.Main).launch {
                            showLoader("Installation Failed", "Ok")
                            safeUnregisterReceiver()
                        }
                    }
                }
            }

            // Store receiver reference for potential cleanup
            currentReceiver = receiver

            try {
                ContextCompat.registerReceiver(
                    activity,
                    receiver,
                    IntentFilter(actionDownloadSubscription),
                    lpaDeclaredPermission,
                    null,
                    ContextCompat.RECEIVER_EXPORTED
                )

                val sub = DownloadableSubscription.forActivationCode(activationCode)

                euIccManager?.downloadSubscription(
                    sub,
                    true,
                    callbackIntent
                ) ?: run {
                    CoroutineScope(Dispatchers.Main).launch {
                        showLoader("eSIM manager not available", "Ok")
                        safeUnregisterReceiver()
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error setting up eSIM installation", e)
                CoroutineScope(Dispatchers.Main).launch {
                    showLoader("Failed to initialize eSIM installation", "Ok")
                    safeUnregisterReceiver()
                }
            }
        }
    }

    private fun safeUnregisterReceiver() {
        try {
            currentReceiver?.let {
                activity.unregisterReceiver(it)
                currentReceiver = null
            }
        } catch (e: IllegalArgumentException) {
            // Receiver was already unregistered
            Log.d(TAG, "Receiver already unregistered")
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering receiver", e)
        }
    }

    private fun isESIMSupported(): Boolean {
        return euIccManager?.isEnabled == true
    }

    private fun showSimpleDialog(
        message: String,
        buttonText: String,
    ) {
        simpleDialog = AlertDialog
            .Builder(activity, android.R.style.Theme_Material_Light_Dialog)
            .setTitle("eSIM")
            .setMessage(message)
            .setPositiveButton(buttonText) { _, _ ->
                hideLoader()
            }
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

            showSimpleDialog(
                message, buttonText
            )
        }
    }

    private fun hideLoader() {
        if (simpleDialog?.isShowing == true) {
            simpleDialog?.dismiss()
        }
    }
}