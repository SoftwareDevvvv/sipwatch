# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Notification plugin rules
-keep class com.dexterous.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}
