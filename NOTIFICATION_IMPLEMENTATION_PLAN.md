# SipWatch Notifications Implementation Plan

## 📱 Current Notification Settings Available

Based on the settings screen analysis, we have these notification toggles:

1. **Daily Notification** - Main toggle for enabling notifications
2. **Morning Tips** - Daily motivational/educational messages
3. **Water Warning** - Norm transition warning for water
4. **Coffee Warning** - Norm transition warning for coffee
5. **Alcohol Warning** - Norm transition warning for alcohol

## 📦 Required Packages (Already Available)

✅ **flutter_local_notifications: ^17.2.1** - Core notification functionality
✅ **timezone: ^0.9.2** - Time zone handling for scheduled notifications
✅ **permission_handler: ^11.0.1** - Managing notification permissions

## 🔧 Platform Setup Required

### Android Setup:

1. **android/app/src/main/AndroidManifest.xml**:

   ```xml
   <!-- Notification permissions -->
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
   <uses-permission android:name="android.permission.VIBRATE" />
   <uses-permission android:name="android.permission.WAKE_LOCK" />
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

   <!-- Notification receiver -->
   <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
   <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
       <intent-filter>
           <action android:name="android.intent.action.BOOT_COMPLETED"/>
           <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
           <action android:name="android.intent.action.QUICKBOOT_POWERON" />
           <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
       </intent-filter>
   </receiver>
   ```

2. **android/app/src/main/res/drawable/** - Add notification icons
3. **Target SDK 33+** for Android 13 notification permissions

### iOS Setup:

1. **ios/Runner/Info.plist**:
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>background-processing</string>
   </array>
   ```
2. **Request notification permissions** in iOS settings

## 🧠 Notification Logic & Triggers

### 1. Daily Notification (Master Toggle)

- **When enabled**: Activates all other notification types
- **When disabled**: Disables ALL notifications regardless of individual toggles
- **Implementation**: Check this first before any notification

### 2. Morning Tips

- **Trigger**: Daily at configurable time (default: 8:00 AM)
- **Content**: Rotating educational messages about hydration
- **Examples**:
  - "Start your day with a glass of water! 💧"
  - "Did you know coffee counts toward your daily fluid intake?"
  - "Moderate alcohol consumption - your body will thank you! 🌟"

### 3. Norm Transition Warnings (Key Feature)

These trigger when consumption **EXCEEDS** the daily limits set in settings:

**Water Warning**:

- **Trigger**: When `totalWaterToday` > `waterDailyGoal`
- **Current Logic**: User sets daily goal (e.g., 2500ml)
- **Notification**: "You've exceeded your daily water goal! Great hydration! 💧"
- **Timing**: Immediately when threshold crossed

**Coffee Warning**:

- **Trigger**: When `totalCoffeeToday` > `coffeeDailyLimit`
- **Current Logic**: Default 400ml limit
- **Notification**: "You've exceeded your daily coffee limit. Consider switching to water! ☕"
- **Timing**: Immediately when threshold crossed

**Alcohol Warning**:

- **Trigger**: When `totalAlcoholToday` > `alcoholDailyLimit`
- **Current Logic**: Default 200ml limit
- **Notification**: "You've reached your alcohol limit for today. Stay hydrated! 🚫🍺"
- **Timing**: Immediately when threshold crossed

## ⚡ Implementation Strategy

### 1. Notification Service Class

Create `NotificationService` with methods:

- `initializeNotifications()`
- `scheduleDailyMorningTip()`
- `checkAndTriggerWarning(DrinkType type, int currentAmount, int limit)`
- `cancelAllNotifications()`

### 2. Integration Points

- **DrinkEntryController**: Add notification checks in `_calculateStats()` method
- **SettingsController**: Save/load notification preferences
- **App Startup**: Initialize notification service and request permissions

### 3. Monitoring Strategy

Use **GetX Workers** in DrinkEntryController to monitor:

```dart
// Watch for changes in daily consumption
ever(totalWaterToday, (amount) => checkWaterWarning(amount));
ever(totalCoffeeToday, (amount) => checkCoffeeWarning(amount));
ever(totalAlcoholToday, (amount) => checkAlcoholWarning(amount));
```

### 4. User Experience

- **Permission Request**: On first app launch or when enabling notifications
- **Settings Integration**: Notifications respect user preferences
- **Immediate Feedback**: Warnings appear as soon as limits are exceeded
- **Daily Reset**: All counters reset at midnight, warnings can trigger again

## 🎯 Key Benefits

1. **Health Awareness**: Users get immediate feedback about consumption
2. **Goal Achievement**: Positive reinforcement for meeting/exceeding water goals
3. **Harm Reduction**: Warnings for excessive coffee/alcohol consumption
4. **Habit Building**: Daily morning tips encourage consistent hydration

## 🔄 Notification Flow

1. **App Launch** → Request permissions & initialize service
2. **User adds drink** → Check if any limits exceeded → Trigger warning if needed
3. **Daily 8 AM** → Send morning tip (if enabled)
4. **Settings change** → Update notification preferences & reschedule as needed

## 🚀 Implementation Steps

### Phase 1: Basic Setup

1. ✅ Create notification service class
2. ✅ Add Android manifest permissions
3. ✅ Add iOS Info.plist configuration
4. ✅ Initialize service in main.dart
5. ✅ Request permissions on app startup

### Phase 2: Core Functionality

1. Implement morning tips scheduling
2. Add consumption monitoring workers
3. Create warning notification logic
4. Integrate with settings toggles

### Phase 3: Enhancement & Testing

1. Add notification icons and styling
2. Test on both Android and iOS
3. Handle edge cases and error scenarios
4. User testing and feedback integration

---

This comprehensive notification system will provide real-time health feedback while respecting user preferences and platform guidelines. The "norm transition warnings" effectively become "limit exceeded" alerts that promote healthy consumption habits.
