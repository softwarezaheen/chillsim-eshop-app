## Gson rules
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

# Stripe
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Flutter and Android Fragment rules
-keep class androidx.fragment.app.Fragment { *; }
-keep class * extends androidx.fragment.app.Fragment { 
    public <init>(...);
}

# Keep all Flutter Fragment classes
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.plugin.** { *; }

# Firebase rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Facebook SDK rules
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

# Flutter plugins
-keep class io.flutter.plugins.** { *; }
-keep class ** implements io.flutter.plugin.common.MethodCallHandler { *; }
-keep class ** implements io.flutter.plugin.common.StreamHandler { *; }

# Keep all classes with native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Flutter WebView
-keep class io.flutter.plugins.webviewflutter.** { *; }

# Keep Fragment constructors specifically
-keepclassmembers class * extends androidx.fragment.app.Fragment {
    public <init>();
    public <init>(android.os.Bundle);
}

# ObjectBox
-keep class io.objectbox.** { *; }
-dontwarn io.objectbox.**

# QR Code Scanner
-keep class net.sourceforge.zbar.** { *; }
-dontwarn net.sourceforge.zbar.**

# Branch SDK
-keep class io.branch.** { *; }
-dontwarn io.branch.**

# Additional Fragment safety rules
-keep class * extends androidx.fragment.app.DialogFragment { *; }
-keep class * extends androidx.fragment.app.ListFragment { *; }
-keep class * extends androidx.fragment.app.PreferenceFragmentCompat { *; }

# Ensure Fragment state can be restored
-keepnames class * extends androidx.fragment.app.Fragment
-keepclassmembers class * extends androidx.fragment.app.Fragment {
    public void setArguments(android.os.Bundle);
    public android.os.Bundle getArguments();
}

# Keep FlutterFragmentActivity specifically
-keep class io.flutter.embedding.android.FlutterFragmentActivity { *; }
-keepclassmembers class io.flutter.embedding.android.FlutterFragmentActivity {
    *;
}

# Keep all constructor parameters for Fragments
-keepclassmembers class * extends androidx.fragment.app.Fragment {
    public <init>();
    public <init>(...);
}

# Prevent obfuscation of Fragment class names used in XML or reflection
-keepnames class * extends androidx.fragment.app.Fragment