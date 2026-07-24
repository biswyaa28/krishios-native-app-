# Keep ONNX Runtime C++ FFI JNI bindings
-keep class com.microsoft.onnxruntime.** { *; }
-keep class ai.onnxruntime.** { *; }
-dontwarn com.microsoft.onnxruntime.**
-dontwarn ai.onnxruntime.**

# Keep Flutter Engine and Plugins JNI interfaces
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# Keep Firebase dependencies
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Hive models & type adapters
-keep class io.realm.transformer.** { *; }

