#import "PerfectLockScreen13.h"
#import <Cephei/HBPreferences.h>

#define IS_iPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

static HBPreferences *pref;
static BOOL removeCCGrabber;
static BOOL doNotWakeWhenFlashlight;
static BOOL noDragOnMediaPlayer;
static BOOL noSwipeToUnlockText;
static BOOL autoRetryFaceID;
static BOOL roundedCorners;
static BOOL quickActionsTransparentBackground;
static BOOL enableAutoRotate;
static BOOL HideBatteryChargingAnimation;
static BOOL hideTodayView;
static BOOL idleTimerDuration;
static long idleDuration;
static BOOL hideDate;
static BOOL disableCamera;

// ------------------------------ REMOVE CC GRABBER ------------------------------

%group removeCCGrabberGroup

	%hook CSTeachableMomentsContainerView

	-(void)_layoutControlCenterGrabberAndGlyph
	{

	}

	%end

%end

// ------------------------------ DO NOT WAKE DISPLAY IF FLASHLIGHT IS ON ------------------------------

%group doNotWakeWhenFlashlightGroup

// Original code by @CPDigitalDarkroom: https://github.com/CPDigitalDarkroom/NoFlashlightWake

	%hook SBLiftToWakeManager

	- (void)liftToWakeController: (id)arg1 didObserveTransition: (long long)arg2 deviceOrientation: (long long)arg3
	{
		if(!([[%c(SBUIFlashlightController) sharedInstance] level] > 0)) %orig;
	}

	%end

	%hook SBTapToWakeController

	- (void)tapToWakeDidRecognize: (id)arg1
	{
		if(!([[%c(SBUIFlashlightController) sharedInstance] level] > 0)) %orig;
	}

	%end

%end

// ------------------------------ DISABLE LOCKSCREEN DRAGGING ON THE MEDIA PLAYER ------------------------------

%group noDragOnMediaPlayerGroup

// Original code by @KritantaDev: https://github.com/KritantaDev/nomediadrag

%hook MRPlatterViewController

	- (void)viewDidLoad
	{
		%orig;
		[self.view setValue: @NO forKey: @"deliversTouchesForGesturesToSuperview"];	
	}

	%end

%end

// ------------------------------ HIDE "SWIPE UP TO UNLOCK" TEXT ------------------------------

%group noSwipeToUnlockTextGroup

	%hook CSTeachableMomentsContainerView

	- (void)setCallToActionLabel: (id)arg
	{
		
	}

	%end

%end

// ------------------------------ AUTO RETRY FACEID ------------------------------

%group autoRetryFaceIDGroup

// Original code by @gilshahar7: https://github.com/gilshahar7/PearlRetry

	%hook SBDashBoardPearlUnlockBehavior

	-(void)_handlePearlFailure
	{
		%orig;
		
		[[%c(SBUIBiometricResource) sharedInstance] noteScreenDidTurnOff];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), 
		^{
			[[%c(SBUIBiometricResource) sharedInstance] noteScreenWillTurnOn];
		});
	}

	%end

%end

// ------------------------------ ROUNDED CORNERS ------------------------------

%group roundedCornersGroup

	%hook SBCoverSheetPanelBackgroundContainerView

	- (void)layoutSubviews
	{
		[self.layer setMasksToBounds: YES];
		[self _setCornerRadius: [[[self window] screen] _displayCornerRadius]];
	}

	%end

%end

// ------------------------------ QUICK ACTIONS TRANSPARENT BACKGROUND ------------------------------

%group quickActionsTransparentBackgroundGroup

	%hook UIVisualEffectView

	- (void)setBackgroundEffects: (id)arg
	{

	}

	%end

%end

// ------------------------------ AUTO ROTATE ------------------------------

%group enableAutoRotateGroup

	%hook CSCoverSheetViewController

	- (BOOL)shouldAutorotate
	{
		return enableAutoRotate;
	}

	%end

%end

// ------------------------------ HIDE BATTERY CHARGING ANIMATION ------------------------------

%group HideBatteryChargingAnimationGroup

	%hook CSCoverSheetViewController

	-(void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3
	{
		%orig(NO, arg2, arg3);
	}

	%end

%end

// ------------------------------ HIDE TODAY VIEW ------------------------------

%group hideTodayViewGroup

	%hook SBMainDisplayPolicyAggregator

	-(BOOL)_allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1
	{
		return NO;
	}

	%end

%end

// ------------------------------ CUSTOM IDLE TIMER DURATION ------------------------------

%group idleTimerDurationGroup

	%hook CSBehavior

	- (void)setIdleTimerDuration: (long long)arg
	{
		%orig(idleDuration);
	}

	%end

%end

// ------------------------------ HIDE DATE ------------------------------

%group hideDateGroup

	%hook SBFLockScreenDateView

	- (void)setContentAlpha: (double)arg1 withSubtitleVisible: (BOOL)arg2
	{
		%orig(1, NO);
	}

	%end

%end

// ------------------------------ DISABLE CAMERA ------------------------------

%group disableCameraGroup

	%hook SBMainDisplayPolicyAggregator

	-(BOOL)_allowsCapabilityLockScreenCameraSupportedWithExplanation:(id*)arg1
	{
		return NO;
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectlockscreen13prefs"];
		[pref registerDefaults:
		@{
			@"removeCCGrabber": @NO,
			@"doNotWakeWhenFlashlight": @NO,
			@"noDragOnMediaPlayer": @NO,
			@"noSwipeToUnlockText": @NO,
			@"autoRetryFaceID": @NO,
			@"roundedCorners": @NO,
			@"quickActionsTransparentBackground": @NO,
			@"enableAutoRotate": @NO,
			@"HideBatteryChargingAnimation": @NO,
			@"hideTodayView": @NO,
			@"idleTimerDuration": @NO,
			@"idleDuration": @3,
			@"hideDate": @NO,
			@"disableCamera": @NO
    	}];

		removeCCGrabber = [pref boolForKey: @"removeCCGrabber"];
		doNotWakeWhenFlashlight = [pref boolForKey: @"doNotWakeWhenFlashlight"];
		noDragOnMediaPlayer = [pref boolForKey: @"noDragOnMediaPlayer"];
		noSwipeToUnlockText = [pref boolForKey: @"noSwipeToUnlockText"];
		autoRetryFaceID = [pref boolForKey: @"autoRetryFaceID"];
		roundedCorners = [pref boolForKey: @"roundedCorners"];
		quickActionsTransparentBackground = [pref boolForKey: @"quickActionsTransparentBackground"];
		enableAutoRotate = [pref boolForKey: @"enableAutoRotate"];
		HideBatteryChargingAnimation = [pref boolForKey: @"HideBatteryChargingAnimation"];
		hideTodayView = [pref boolForKey: @"hideTodayView"];
		idleTimerDuration = [pref boolForKey: @"idleTimerDuration"];
		idleDuration = [pref integerForKey: @"idleDuration"];
		hideDate = [pref boolForKey: @"hideDate"];
		disableCamera = [pref boolForKey: @"disableCamera"];

		if(removeCCGrabber) %init(removeCCGrabberGroup);
		if(doNotWakeWhenFlashlight) %init(doNotWakeWhenFlashlightGroup);
		if(noDragOnMediaPlayer) %init(noDragOnMediaPlayerGroup);
		if(noSwipeToUnlockText) %init(noSwipeToUnlockTextGroup);
		if(autoRetryFaceID) %init(autoRetryFaceIDGroup);
		if(roundedCorners) %init(roundedCornersGroup);
		if(quickActionsTransparentBackground) %init(quickActionsTransparentBackgroundGroup);
		%init(enableAutoRotateGroup);
		if(HideBatteryChargingAnimation) %init(HideBatteryChargingAnimationGroup);
		if(hideTodayView) %init(hideTodayViewGroup);
		if(idleTimerDuration) %init(idleTimerDurationGroup);
		if(hideDate) %init(hideDateGroup);
		if(disableCamera) %init(disableCameraGroup);
	}
}