# Flutter engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Play Store (deferred components)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep models used for JSON / Hive serialization
-keep class com.krishios.krishios.** { *; }

# Keep annotations used by Riverpod / json_serializable
-keepattributes *Annotation*, RuntimeVisibleAnnotations
-keep class **.riverpod.** { *; }
-keep class **.freezed.** { *; }

# General Android
-dontwarn java.lang.instrument.ClassFileTransformer
-dontwarn sun.misc.SignalHandler
