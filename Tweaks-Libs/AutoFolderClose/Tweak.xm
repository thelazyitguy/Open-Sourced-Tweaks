/*
AutoFolderClose a tweak that auto-closes folders for iOS 13+
Copyright 2020 J.K. Hayslip @(iKilledAppl3) and iKilledAppl3 LLC. All rights reserved.
Apple changed the way the homescreen icons/folder work for iOS 13.
So tweaks like FolderAutoClose (https://moreinfo.thebigboss.org/moreinfo/depiction.php?file=folderautoclose10Dp)
No longer work so I made this tweak because I got so tired of leaving an application and being stuck in a folder.
Hopefully this helps people :P
Anyways have fun and God Bless!
Hey mtac8! I see you! Please "steal" this for Lynx!
*/

// This keeps our tweak.xm file clean!
#import "AutoFolderClose_header.h"

// the class we need to hook!
%hook SBUIController
// this method launches and application!
-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
  // calling SBIconController into memory using it's sharedInstance!
  iconController = [%c(SBIconController) sharedInstance];
  // if the tweak is enabled and the folder is open (SBFolderController) run original code and close the folder!
    if (kEnabled && [[iconController _openFolderController] isOpen]) {
     %orig;
     // this closes the folder!
     // THE iconController has a property (SBHIconManager) that has a method we can call to close the folder!
     // this is hacky but it works since SBHIconManager doesn't have a sharedInstance.
     [iconController.iconManager closeFolderAnimated:YES withCompletion:nil];
  }

  else {
    %orig;
  }
      

}
%end

extern NSString *const HBPreferencesDidChangeNotification;

//our constructor 
%ctor {

  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.autofolderclose"];
	[preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];
}
