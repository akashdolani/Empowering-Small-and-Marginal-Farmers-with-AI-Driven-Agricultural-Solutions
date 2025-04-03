# Existing rules (if you added them from my previous suggestion)
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# Add this rule from missing_rules.txt to suppress the specific warning
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Optional: Keep native methods if needed
-keepclasseswithmembernames class org.tensorflow.lite.* {
    native <methods>;
}