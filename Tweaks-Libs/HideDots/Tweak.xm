#import "Tweak.h"

//tweak settings.
static bool hs = false;
static bool ls = false;


//amash shteky tra
static void reloadPreferences() {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"cf.1di4r.hidedotspref"];
    hs = [([file objectForKey:@"isHS"] ?: @(YES)) boolValue];
  ls = [([file objectForKey:@"isLS"] ?: @(YES)) boolValue];



}

%group HideDots
    %hook SBIconListPageControl
    - (id)initWithFrame:(CGRect)frame
    {

  if(hs){




    	return nil; %orig;



}else {
  return %orig;
}

}
%end

%hook SBDashBoardPageControl
- (id)initWithFrame:(CGRect)frame
{

if(ls){




  return nil; %orig;


}else {
  return %orig;
}

}
%end


%end

%group HideDots13
    %hook SBIconListPageControl
    - (id)initWithFrame:(CGRect)frame
    {
  if(hs){




    	return nil; %orig;



}else {
  return %orig;
}

}
%end

%hook CSPageControl
- (id)initWithFrame:(CGRect)frame
{
 
if(ls){



  return nil; %orig;


}else {
  return %orig;
}

}
%end


%end
//Preferences stuff

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
}




%ctor{
 reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, (CFStringRef)@"cf.1di4r.hidedotspref/ReloadPrefs", NULL, kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
   float version = [[[UIDevice currentDevice] systemVersion] floatValue];
   if (version >= 13){
     %init(HideDots13);
   }else if (version < 13) {
     %init(HideDots)
   }else{
     // unsupported iOS versions
   }
    
}
