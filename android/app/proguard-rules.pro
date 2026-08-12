# Keep WorkManager internal classes and database
-keep class androidx.work.impl.WorkDatabase** { *; }
-keep class * extends androidx.work.impl.WorkDatabase { *; }
-keep class com.soteria.MainActivity { *; }

# Keep Room generated implementations
-keep class * extends androidx.room.RoomDatabase { *; }
-dontwarn androidx.work.impl.**
