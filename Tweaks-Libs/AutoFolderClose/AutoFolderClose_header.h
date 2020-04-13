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

// headers/classes we need
@import UIKit;
#import <Cephei/HBPreferences.h>

// is the tweak enabled? 
BOOL kEnabled;

// Cepehi is King!
HBPreferences *preferences;

// apple interfaces

@interface SBHIconManager : NSObject
-(void)closeFolderAnimated:(BOOL)arg1 withCompletion:(id)arg2;
@end

@interface SBFolderController : NSObject 
-(BOOL)isOpen;
@end

@interface SpringBoard : UIApplication
+(id)sharedApplication;
-(void)_simulateHomeButtonPress;
@end

@interface SBIconController : UIViewController
@property (nonatomic,readonly) SBFolderController *currentFolderController;
@property (nonatomic,readonly) SBFolderController *openFolderController;
@property (nonatomic,readonly) SBHIconManager *iconManager; 
+(id)sharedInstance;
-(SBFolderController *)_openFolderController;
-(void)iconManager:(id)arg1 launchIconForIconView:(id)arg2;
-(void)iconManager:(SBHIconManager *)arg1 willCloseFolderController:(SBFolderController *)arg2;
@end

// statically call the icon controller and make sure it's nil
// We do this so we don't have to call %c yadada over and over again.
static SBIconController *iconController = nil;
