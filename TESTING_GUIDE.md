# SipWatch App - Comprehensive Testing Guide

## 🚨 **RECENT BUG FIX: DECIMAL CAFFEINE VALUES**

**FIXED**: Caffeine values with decimals (e.g., 25.5 mg) now save properly!

- ✅ **Issue**: Decimal caffeine values (like 25.5) were getting lost when saving drinks
- ✅ **Fix**: Changed caffeine field from `int` to `double` to support decimal values
- ✅ **Test**: Try entering caffeine values like 25.5, 100.2, 0.5 and verify they save correctly

## 🆕 **NEW FEATURE: AUTO UNIQUE FACTOR & SUFFIX ICONS**

**ADDED**: Smart unique factor selection and suffix text in Add Fluid screen!

- ✅ **Auto Selection**: When drink type changes to Coffee → Unique Factor automatically sets to "Caffeine"
- ✅ **Auto Selection**: When drink type changes to Alcohol → Unique Factor automatically sets to "Alcohol"
- ✅ **Suffix Icons**: Caffeine amount field shows "mg" suffix, Alcohol shows "%" suffix
- ✅ **Test**: Change drink types and verify unique factor updates automatically and suffixes appear

---

## 🧪 **COMPLETE FUNCTIONALITY TESTING CHECKLIST**

### **📱 BASIC APP FUNCTIONALITY**

#### **1. App Launch & Navigation**

- [x] App launches without crashes
- [x] All bottom navigation tabs work (Today, Calendar, Stats, Settings)
- [x] No visual glitches on startup
- [x] App icon displays correctly on device

#### **2. Settings Screen Testing**

- [x] **Personal Information:**

  - [x] Enter name and save → Check if persisted after app restart
  - [x] Select profile image from gallery → Verify image displays and persists
  - [x] Take photo with camera → Verify image displays and persists
  - [x] Save button works and shows confirmation

- [x ] **Notification Settings:**

  - [x] Toggle each notification setting (Daily, Morning Tips, Water/Coffee/Alcohol warnings)
  - [x] Save settings → Restart app → Verify settings are preserved
  - [x] Test Notifications button only appears in debug mode

- [x] **Daily Norm Settings:**

  - [x] Change water/coffee/alcohol daily limits
  - [x] Save and verify values persist after restart
  - [x] Check if water daily goal updates in Today screen

- [x] **Body Fluid Calculation:**
  - [x] Change gender, weight, activity level
  - [x] Verify daily norm calculation updates automatically
  - [x] Save and check persistence after restart

---

### **🏠 TODAY SCREEN TESTING**

#### **3. Today Screen Display**

- [x] Total consumption displays correctly (ml)
- [x] Daily norm percentage calculates correctly
- [x] Daily consumption graph shows proper ratios
- [x] "Cups drunk" section displays properly
- [x] "+ New Drink" button works

#### **4. Drink Cards Testing**

- [x] Drink cards display: image, name, time, volume, unique factors
- [x] Edit button shows text properly (not vertical letters)
- [x] Edit button functionality works
- [x] Delete button works and removes drink
- [x] No overflow issues with long drink names
- [x] Time displays close to drink name (not far apart)
- [x] Unique factors show only for coffee (caffeine) and alcohol (percentage)

---

### **➕ ADD FLUID SCREEN TESTING**

#### **5. Adding New Drinks**

- [x] Select drink type (Water, Coffee, Alcohol only - no "Other")
- [x] Volume input works properly
- [x] Time picker functions correctly
- [x] Add custom image from gallery
- [x] Take photo for drink image
- [x] **Coffee specific:** Enter caffeine content
- [x] **Alcohol specific:** Enter alcohol percentage
- [x] Save drink and verify it appears in Today screen

#### **6. Editing Existing Drinks**

- [x] Click Edit on drink card → Opens Add Fluid screen with pre-filled data
- [x] Modify volume, time, image, name
- [x] Save changes → Verify updates in Today screen
- [x] Cancel editing → No changes saved

---

### **📅 CALENDAR SCREEN TESTING**

#### **7. Calendar Functionality**

- [x] Calendar displays current month
- [x] Navigate between months
- [x] Past dates show historical data correctly
- [x] Future dates show appropriate state

#### **8. Calendar Data Display**

- [x] Each date shows total consumption
- [x] Drink types are color-coded properly
- [x] Daily norm percentage shows for each day
- [x] No data corruption when viewing different dates

---

### **📊 STATS SCREEN TESTING**

#### **9. Weekly Stats**

- [x] Weekly graph displays current week data
- [x] All 7 days show correct consumption
- [x] Graph updates when new drinks added
- [x] Weekly totals calculate correctly

#### **10. Monthly Stats**

- [ ] Monthly graph shows exactly 4 segments (Week 1, Week 2, Week 3, Week 4)
- [ ] All days of month are properly distributed across 4 weeks
- [ ] Month navigation works properly
- [ ] Data accuracy across different months

---

### **🔔 NOTIFICATION SYSTEM TESTING**

#### **11. Notification Setup (Debug Mode)**

- [x] Navigate to Test Notifications (should only show in debug mode)
- [x] Test immediate notification → Should appear
- [x] Test scheduled notification → Wait and verify it appears
- [x] Test all notification types work

#### **12. Warning Notifications**

- [x] Add drinks to exceed water daily goal → Check if warning triggers
- [x] Add coffee to exceed daily limit → Check if warning triggers
- [x] Add alcohol to exceed daily limit → Check if warning triggers
- [x] Edit drinks to trigger warnings → Verify warnings still work

#### **13. Daily Notifications**

- [x] Enable daily notifications in settings
- [x] Wait for scheduled time or test with immediate notification
- [x] Verify morning tips work if enabled

---

### **💾 DATA PERSISTENCE TESTING**

#### **14. Data Survival Tests**

- [ ] Add multiple drinks → Close app → Reopen → Verify all drinks present
- [ ] Change all settings → Close app → Reopen → Verify all settings preserved
- [ ] Add user images → Close app → Reopen → Verify images still display
- [ ] Set personal info → Close app → Reopen → Verify name and image preserved

#### **15. Cross-Screen Data Consistency**

- [ ] Add drink in Add Fluid → Check appears in Today, Calendar, Stats
- [ ] Edit drink → Verify changes reflect across all screens
- [ ] Delete drink → Verify removal across all screens
- [ ] Change daily goals → Verify updates in Today screen progress

---

### **🔍 ERROR HANDLING & EDGE CASES**

#### **16. Input Validation**

- [ ] Enter extremely large volume (9999ml) → App handles gracefully
- [ ] Enter zero or negative volume → App prevents or handles
- [ ] Enter very long drink names → Text truncates properly
- [ ] Test with no internet connection → App works offline

#### **17. Image Handling**

- [ ] Select corrupted or invalid image → App handles gracefully
- [ ] Camera permission denied → App shows appropriate message
- [ ] Gallery permission denied → App shows appropriate message
- [ ] Delete image file from device → App fallback works

#### **18. Memory & Performance**

- [ ] Add 50+ drinks → App performance remains good
- [ ] Navigate rapidly between screens → No crashes
- [ ] Rotate device (if supported) → Layout remains proper
- [ ] Background/foreground app multiple times → Data persists

---

### **🎨 UI/UX TESTING**

#### **19. Visual Consistency**

- [ ] All text readable and properly sized
- [ ] Color scheme consistent across screens
- [ ] Icons display properly
- [ ] Spacing and padding look good
- [ ] Dark/light theme handling (if applicable)

#### **20. Responsive Design**

- [ ] Test on different screen sizes
- [ ] Landscape orientation (if supported)
- [ ] Very long text content handles properly
- [ ] Small screen devices work well

---

### **🚨 STRESS TESTING**

#### **21. High Volume Testing**

- [ ] Add 100+ drinks across multiple days
- [ ] Test with very long drink names
- [ ] Test with maximum caffeine/alcohol percentages
- [ ] Navigate rapidly between all screens

#### **22. Boundary Testing**

- [ ] Test on January 1st (new year boundary)
- [ ] Test on month boundaries (month-end/start)
- [ ] Test with system time changes
- [ ] Test with different device locales/languages

---

### **✅ EXPECTED BEHAVIOR VERIFICATION**

#### **23. Core Features Working**

- [ ] Only 3 drink types: Water, Coffee, Alcohol (no "Other")
- [ ] Only user-added images (no asset images)
- [ ] Unique factors: Caffeine for coffee, Alcohol % for alcohol, None for water
- [ ] All data persists across app restarts
- [ ] Notifications work based on settings
- [ ] All screens are reactive (update immediately on data changes)

#### **24. Business Logic Verification**

- [ ] Daily norm calculations are accurate
- [ ] Body fluid requirements calculate correctly based on gender/weight/activity
- [ ] Consumption percentages add up to 100%
- [ ] Weekly/monthly stats show accurate totals
- [ ] Notification warnings trigger at appropriate thresholds

---

### **📋 TESTING RECORD TEMPLATE**

For each test, record:

- ✅ **PASS** - Works as expected
- ❌ **FAIL** - Doesn't work, note the issue
- ⚠️ **ISSUE** - Works but has minor problems

**Example:**

```
[✅] Add new water drink - Works perfectly
[❌] Edit button text - Text not showing, appears blank
[⚠️] Long drink names - Text truncates but spacing looks odd
```

---

### **🎯 PRIORITY TESTING ORDER**

**High Priority (Test First):**

1. Basic navigation and app launch
2. Adding and editing drinks
3. Data persistence after app restart
4. Today screen display and functionality

**Medium Priority:** 5. Settings screen functionality 6. Calendar and Stats screens 7. Notification system 8. Image handling

**Low Priority (Test Last):** 9. Edge cases and error handling 10. Performance and stress testing 11. UI/UX polish issues

---

### **🔧 DEBUGGING TIPS**

- **Check console logs** for error messages
- **Test on both debug and release builds**
- **Test with notifications enabled in device settings**
- **Clear app data and test fresh installation**
- **Test with different Android/iOS versions if possible**

This comprehensive testing will help you identify any remaining issues and ensure your SipWatch app is rock-solid before release!
