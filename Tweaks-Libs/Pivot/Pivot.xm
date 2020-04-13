#include "Pivot.h"


#pragma mark Globals


NSDictionary *prefs = nil;

// 0: Disabled
// 1: Plus Style
// 2: iPad Style
static int _pfMode = 1;
static BOOL _pfDontRotateWallpaper = YES;
static BOOL _pfMedusa = YES;
static BOOL _pfInvert = YES;
static CGFloat _pfVPad = 5;

// 2 = Plus Style
// 1 = iPad Style
// Anything else disables it. 
static int _rtRotationStyle = 2;

%group iOS6to12



%hook SBRootIconListView 


+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1
{
    if (UIDeviceOrientationIsLandscape(arg1))
        return [%c(SBRootIconListView) iconRowsForInterfaceOrientation:1];
    return %orig;
}

+ (NSUInteger)iconRowsForInterfaceOrientation:(NSInteger)arg1
{
    if (UIDeviceOrientationIsLandscape(arg1))
        return [%c(SBRootIconListView) iconColumnsForInterfaceOrientation:1];
    return %orig;
}

- (NSUInteger)iconRowsForSpacingCalculation
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        return [%c(SBRootIconListView) iconColumnsForInterfaceOrientation:1];
    return %orig;
}

+ (NSUInteger)maxVisibleIconRowsInterfaceOrientation:(NSInteger)arg1
{    
    if (UIDeviceOrientationIsLandscape(arg1))
        return [%c(SBRootIconListView) iconColumnsForInterfaceOrientation:1];
    return %orig;
}

%end


%end

%group iOS7Down


%hook SBOrientationLockManager

- (void)setLockOverrideEnabled:(BOOL)enabled forReason:(NSString *)reason
{
	if ([reason isEqualToString:@"SBOrientationLockForSwitcher"])
		enabled = NO;
	%orig();
}

%end

%end


%group iOS7Up


%hook SBWallpaperController

-(BOOL)_isAcceptingOrientationChangesFromSource:(NSInteger)arg
{
    return (!_pfDontRotateWallpaper);
}

%end 


%end



%group iOS8Up

%hook SpringBoard

- (NSUInteger)homeScreenRotationStyle
{
    return _rtRotationStyle;
}

- (BOOL)homeScreenSupportsRotation
{
    return (_rtRotationStyle != 0);
}

%end

%end



%group iOS9Up


%hook SpringBoard

- (BOOL)supportsPortraitUpsideDownOrientation
{
    return _pfInvert;
}

%end


%hook SBApplication

- (BOOL)isMedusaCapable 
{
    if (_pfMedusa) 
    {
	    return YES;
    }
    return %orig;
}

%end


%hook SBHomeScreenViewController

- (BOOL)homeScreenAutorotatesEvenWhenIconIsDragging 
{
    if (_pfMode !=0) 
    {
        return TRUE;
    }
    return %orig;
}

- (void)setHomeScreenAutorotatesEvenWhenIconIsDragging:(BOOL)arg1 
{
    if (_pfMode !=0) 
    {
        arg1 = TRUE;
        return %orig(arg1);
    }
    return %orig;
}

%end


%end


%group iOS10Up


%hook SBDashBoardViewController
- (BOOL)shouldAutorotate 
{
    if(_pfMode != 0) 
    {
        return TRUE;
    }

    return %orig;
}
%end

%hook SBCoverSheetWindow

- (BOOL)_shouldAutorotateToInterfaceOrientation:(NSInteger)arg checkForDismissal:(BOOL)arg1 isRotationDisabled:(BOOL *)arg2
{
    BOOL x = %orig;

    return (_pfMode != 0) ? YES : x;
}

- (BOOL)_shouldAutorotateToInterfaceOrientation:(NSInteger)arg
{
    BOOL x = %orig; 

    return (_pfMode != 0) ? YES : x;
}

%end

%hook SBCoverSheetPrimarySlidingViewController 

- (BOOL)shouldAutorotate 
{
    return (_pfMode != 0) ? YES : %orig;
}

%end

%hook CSCoverSheetViewController 

- (BOOL)shouldAutorotate
{
    return (_pfMode != 0) ? YES : %orig;
}

- (BOOL)shouldAutorotateForSource:(int)arg 
{
    return (_pfMode != 0) ? YES : %orig(arg);
}

%end

@interface SparkAlwaysOnWindow : UIWindow
@end

@interface PivotSparkRotationController : UIViewController
@end

@implementation PivotSparkRotationController
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    {
        return YES;
    }
@end

%hook SparkAlwaysOnWindow 

- (id)initWithFrame:(CGRect)frame 
{
    id x = %orig;

    self.rootViewController = [[PivotSparkRotationController alloc] init];

    return x;
}
%end


%end

%group iOS13


%hook SBIconListGridLayoutConfiguration 

- (UIEdgeInsets)landscapeLayoutInsets
{   
    UIEdgeInsets x = %orig;

    NSUInteger rows = MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows");
    NSUInteger columns = MSHookIvar<NSUInteger>(self, "_numberOfPortraitColumns"); 
    BOOL i = ( !( rows == 3 && columns == 3 ) && !( rows <=2 && columns <=5));
    CGFloat h = [(SBIconController *)[%c(SBIconController) sharedInstance] _rootFolderController].dockHeight - 10;
    if (i)
    {
        return UIEdgeInsetsMake(
            5,
            x.left + h,
            5, // * 2 because regularly it was too slow
            x.right + h*0.5
        );
    }
    else 
        return x;
}

%end

%end


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//
//
// Pivot Preferences
// #pragma Preferences
//
//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

static void *observer = NULL;

static void reloadPrefs() 
{
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) 
    {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) 
        {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs) 
            {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } 
    else 
    {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}



static void preferencesChanged() 
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    _pfMode = [[prefs valueForKey:@"rotationMode"] integerValue] ?: 1;
    _pfDontRotateWallpaper = [prefs objectForKey:@"lockWallpaper"] ? [[prefs valueForKey:@"lockWallpaper"] boolValue] : YES;
    _pfMedusa = [prefs objectForKey:@"medusa"] ? [[prefs valueForKey:@"medusa"] boolValue] : YES;
    _pfInvert = [prefs objectForKey:@"invert"] ? [[prefs valueForKey:@"invert"] boolValue] : YES;
    _pfVPad = [[prefs valueForKey:@"verticalPad"] floatValue] ?: 5.0;

    if (_pfMode == 1) _rtRotationStyle = 2; 
    else if (_pfMode == 2) _rtRotationStyle = 1;
    else _rtRotationStyle = 0;
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//
//
// Pivot Constructor
// #pragma ctor
//
//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

%ctor 
{
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        &observer,
        (CFNotificationCallback)preferencesChanged,
        kSettingsChangedNotification,
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
    
    if (kCFCoreFoundationVersionNumber > 840) 
        %init(iOS7Up);
    if  (kCFCoreFoundationVersionNumber < 1000)
        %init(iOS7Down);
    if (kCFCoreFoundationVersionNumber > 1000)
        %init(iOS8Up);
    if (kCFCoreFoundationVersionNumber > 1200)
        %init(iOS9Up);
    if (kCFCoreFoundationVersionNumber > 1300)
        %init(iOS10Up);
    if (kCFCoreFoundationVersionNumber > 1600)
        %init(iOS13);
    else 
        %init(iOS6to12);
}
