plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.prenava.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    kotlin {
        jvmToolchain(17)
    }

    defaultConfig {
        // Play Store Application ID - must be unique
        applicationId = "com.prenava.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        // Release signing configuration for Play Store
        // Create keystore using: keytool -genkey -v -keystore prenava-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
        // Store keystore in: android/keystore/prenava-release.jks
        // Set environment variables: KEYSTORE_PASSWORD and KEY_PASSWORD
        create("release") {
            // Uncomment and configure when keystore is ready
            // storeFile = file("../../keystore/prenava-release.jks")
            // storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            // keyAlias = "release"
            // keyPassword = System.getenv("KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        release {
            // Use release signing config when keystore is configured
            // For now, using debug keys for testing
            signingConfig = signingConfigs.getByName("debug")

            // Enable code shrinking and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true

            // ProGuard rules file
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    applicationVariants.all {
        val variant = this
        variant.outputs
            .map { it as com.android.build.gradle.internal.api.BaseVariantOutputImpl }
            .forEach { output ->
                val abi = output.getFilter(com.android.build.OutputFile.ABI) ?: ""
                val suffix = if (abi.isNotEmpty()) "-$abi" else ""
                output.outputFileName = "prenava${suffix}.apk"
            }
    }
}

flutter {
    source = "../.."
}
