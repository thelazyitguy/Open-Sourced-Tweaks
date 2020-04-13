/*

Dark Mode for Zenith's Grabber view!
Copyright 2020 J.K. Hayslip (@iKilledAppl3) & ToxicAppl3 INSDC/iKilledAppl3 LLC.
All code was written for learning purposes and credit must be given to the original author.

Written for Cooper Hull, @(mac-user669).


*/

#import "ZenithDark.h"

// We then hook the class in this case Zenith's grabber view is called “ZNGrabberAccessoryView” 
%hook ZNGrabberAccessoryView

// this is called when iOS 13's dark mode is enabled!
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
   %orig(previousTraitCollection);
  if (kEnabled) { 
  // if the tweak is enabled and the version is iOS 13 or later run our code
    if (@available(iOS 13, *)) {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
       [self setBackgroundColor:kDarkModeColor];
    }

    else {
     [self setBackgroundColor:kLightModeColor];
    }
  }
}

else {
  %orig(previousTraitCollection);
}

}



// the method we  modify is this method that is called from UIImageView to set the backgroundColor of the image view. 
// Since the grabber view is of type UIImageView we can modify this method :)
-(void)setBackgroundColor:(UIColor *)backgroundColor {
  %orig;
  if (kEnabled) {
  // by default have our tweak overide this.
    if (@available(iOS 13, *)) {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
       %orig(kDarkModeColor);
    }
  }

    else {
    %orig;
    }
  }
}

// we need to make sure we tell theos that we are finished hooking this class not doing so with cause the end of the world :P
%end



// Load preferences to make sure changes are written to the plist
static void loadPrefs() {

  // Thanks to skittyblock!
  CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.mac-user669.zenithdark"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  if(keyList) {
    prefs = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.mac-user669.zenithdark"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);
  } else {
    prefs = nil;
  }

  if (!prefs) {
   prefs = [NSMutableDictionary dictionaryWithContentsOfFile:PLIST_PATH];

  }
    //our preference values that write to a plist file when a user selects somethings
  kEnabled = [([prefs objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
}


// thanks to skittyblock!
static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPrefs();
}

// our constructor
%ctor {
  // load our prefs
 loadPrefs(); 
 CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.mac-user669.zenithdark.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  // We use this to make sure we load Zenith's dynamic library at runtime so we can modify it with our tweak.
dlopen ("/Library/MobileSubstrate/DynamicLibraries/Zenith.dylib", RTLD_NOW);

}