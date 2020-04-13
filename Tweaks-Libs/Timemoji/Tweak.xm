#import "Tweak.h"
//Preferences stuff
static bool enabled = true;
//list of emojis
static NSString *yakam = @"🌗";

static NSString *dwam = @"🔅";

static NSString *seyam = @"🔆";

static NSString *chwaram = @"✨";

static NSString *penjam = @"🌙";


//the emojis that have been set above, nearly have no rule in the tweak, they are just like placeholders


static void reloadPreferences() {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"cf.1di4r.timemojiprefs"];
    enabled = [([file objectForKey:@"isEnabled"] ?: @(YES)) boolValue];
    yakam = [file objectForKey:@"emoji1"];
    dwam = [file objectForKey:@"emoji2"];
    seyam = [file objectForKey:@"emoji3"];
    chwaram = [file objectForKey:@"emoji4"];
    penjam = [file objectForKey:@"emoji5"];

}

// the fun begins from here :P
@interface SBStatusBarStateAggregator : NSObject
-(void)_updateTimeItems;
@end




%group Timemoji
%hook SBStatusBarStateAggregator



-(void)_updateTimeItems {
  reloadPreferences();
  	if(enabled){

  NSDateFormatter *dateFormat = MSHookIvar<NSDateFormatter *>(self, "_timeItemDateFormatter");
  NSDate * now = [NSDate date];
  [dateFormat setDateFormat:@"HH:mm a"];
  NSString *currentime = [dateFormat stringFromDate:now];

    [currentime floatValue];

      if ([currentime floatValue] <= 03.00 ){
           [dateFormat setDateFormat: [NSString stringWithFormat:@"h:mm %@", yakam]];

     }if ([currentime floatValue] >= 04.00 ){
           [dateFormat setDateFormat: [NSString stringWithFormat:@"h:mm %@", dwam]];

     }if ([currentime floatValue] >= 08.00 ){
           [dateFormat setDateFormat: [NSString stringWithFormat:@"h:mm %@", seyam]];

     }if ([currentime floatValue] >= 18.00 ){
          [dateFormat setDateFormat: [NSString stringWithFormat:@"h:mm %@", chwaram]];

     }if ([currentime floatValue] >= 21.00 ){
          [dateFormat setDateFormat: [NSString stringWithFormat:@"h:mm %@", penjam]];
    }



  %orig;

}else {
  %orig;
}

}



%end
%end

//Preferences stuff

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
}




%ctor{
    reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, (CFStringRef)@"cf.1di4r.timemojiprefs/ReloadPrefs", NULL, kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    %init(Timemoji);
}
