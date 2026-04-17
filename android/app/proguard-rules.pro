# Prenava App - ProGuard Configuration
# Rules for shrinking and obfuscating release builds

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }
-keep class com.crashlytics.android.** { *; }

# Gson (if used for JSON serialization)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# OkHttp and Retrofit (if used)
-dontwarn okhttp3.**
-dontwarn okio.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Dio HTTP client
-keep class com.dio.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# BLoC pattern
-keep class **Bloc_** { *; }
-keep class **_Bloc { *; }

# Riverpod
-keep class **.{ @com.riverpod_annotate.Provider, @com.riverpod_annotate.ProviderHolder } { *; }
-keep class **.{@riverpod.Provider, @riverpod.ProviderHolder} { *; }

# Go Router
-keep class go_router.** { *; }

# Preserve line numbers for debugging (remove for production obfuscation)
-keepattributes SourceFile,LineNumberTable

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom views
-keepclasseswithmembers class * {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
