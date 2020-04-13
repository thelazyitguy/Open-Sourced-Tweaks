#define CHECK_TARGET
#import "../PS.h"
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SBDeviceApplicationSceneEntity.h>
#import <SpringBoard/SBMainWorkspace.h>
#import <SpringBoard/SBWorkspaceTransitionRequest.h>
#import <UIKit/UIKit.h>
#import <IOKit/hid/IOHIDEvent.h>
//#import <Cephei/HBPreferences.h>

#define IOHIDEventFieldOffsetOf(field) (field & 0xffff)
#define kIOHIDEventFieldDigitizerAuxiliaryPressure 0xB000B
#define kIOHIDEventFieldDigitizerTiltX 0xB000D
#define kIOHIDEventFieldDigitizerDensity 0xB0012

typedef NS_ENUM(uint32_t, IOHIDDigitizerEventUpdateMask) {
    kIOHIDDigitizerEventUpdateAuxiliaryPressureMask         = 1<<IOHIDEventFieldOffsetOf(kIOHIDEventFieldDigitizerAuxiliaryPressure),
    kIOHIDDigitizerEventUpdateTiltXMask                     = 1<<IOHIDEventFieldOffsetOf(kIOHIDEventFieldDigitizerTiltX),
    kIOHIDDigitizerEventUpdateDensityMask                   = 1<<IOHIDEventFieldOffsetOf(kIOHIDEventFieldDigitizerDensity),
};

/*HBPreferences *preferences;
NSString *tweakIdentifier = @"com.PS.PencilPro";
BOOL enabled;
NSString *quickNoteAppID = @"xyz.willy.Zebra";*/

@interface UIEvent (Private)
- (IOHIDEventRef)_hidEvent;
@end

@interface UITouchesEvent : UIEvent
@end

@interface UIPencilEvent : UIEvent {
	NSMutableSet* _trackedInteractions;
}
@property (nonatomic, retain) NSMutableSet *trackedInteractions;
- (NSMutableSet *)trackedInteractions;
- (id)_init;
- (id)collectAllActiveInteractions;
- (void)_sendEventToInteractions;
- (void)registerInteraction:(id)arg1;
- (void)deregisterInteraction:(id)arg1;
- (void)setTrackedInteractions:(NSMutableSet *)arg1;
@end

@interface PNPChargingStatusView : UIView
@property (assign,nonatomic) NSInteger chargingState; 
- (void)beginPairing;
@end

@interface SBMainWorkspaceTransitionRequest : SBWorkspaceTransitionRequest
@property (assign,nonatomic) NSInteger source;
@end

CFArrayRef (*_IOHIDEventGetChildren)(IOHIDEventRef);
IOHIDEventType (*_IOHIDEventGetType)(IOHIDEventRef);
CFIndex (*_IOHIDEventGetIntegerValue)(IOHIDEventRef, IOHIDEventField);

BOOL (*SBWorkspaceApplicationCanLaunchWhilePasscodeLocked)(SBApplication *app);
void (*SBWorkspaceActivateApplicationFromURL)(NSURL *url, uint8_t arg2, void (^)(SBMainWorkspaceTransitionRequest *));

/*%group SBWorkspace

%hookf(BOOL, SBWorkspaceApplicationCanLaunchWhilePasscodeLocked, SBApplication *app) {
	return YES;
}

%end

%hook SBDashBoardApplicationLauncher

- (void)_launchQuickNote {
	NSLog(@"PencilPro: Quick Note App: %@", quickNoteAppID);
	if (quickNoteAppID.length == 0) {
		%orig;
		return;
	}
	SBWorkspaceActivateApplicationFromURL([NSURL URLWithString:@"zbra://"], 0, ^(SBMainWorkspaceTransitionRequest *request) {
		request.source = 13;
	});
}

%end*/

%group SpringBoard

%hook UIGestureRecognizer

- (void)sb_setStylusTouchesAllowed:(BOOL)allowed {
	%orig(YES);
}

%end

%hook UIScreenEdgePanGestureRecognizer

+ (BOOL)_shouldSupportStylusTouches {
	return YES;
}

%end

%hook _UIExclusiveTouchGestureRecognizer

- (void)setMaximumAbsoluteAccumulatedMovement:(CGPoint)point {
	%orig(point.x && point.y ? CGPointMake(800, 800) : point);
}

%end

%hook FBExclusiveTouchGestureRecognizer

- (void)setMaximumAbsoluteAccumulatedMovement:(CGPoint)point {
	%orig(point.x && point.y ? CGPointMake(800, 800) : point);
}

%end

%hook SBSystemGestureManager

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture1 shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)gesture2 {
	return NO;
}

%end

%end

bool hasEdgePendingOrLocked(UITouchesEvent *event) {
	IOHIDEventRef eventRef = [event _hidEvent];
	if (eventRef == NULL)
		return false;
	CFArrayRef children = _IOHIDEventGetChildren(eventRef);
	if (children == NULL)
		return false;
	CFIndex count = CFArrayGetCount(children);
	if (count <= 0)
		return false;
	uint8_t i = 1;
	CFIndex j = 0;
	while (true) {
		IOHIDEventRef ref = (IOHIDEventRef)CFArrayGetValueAtIndex(children, j);
		if (_IOHIDEventGetType(ref) == kIOHIDEventTypeDigitizer) {
			CFIndex mask = _IOHIDEventGetIntegerValue(ref, kIOHIDEventFieldDigitizerEventMask);
			// & 0x42800
			if (mask & (kIOHIDDigitizerEventUpdateDensityMask | kIOHIDDigitizerEventUpdateTiltXMask | kIOHIDDigitizerEventUpdateAuxiliaryPressureMask))
				break;
			// Pencil
			if (mask & 0x70000007)
				break;
    	}
		j = i++;
		if (count <= j)
			return false;
	}
	return true;
}

%group UIKitFunction

bool (*_UIEventHasEdgePendingOrLocked)(UITouchesEvent *) = NULL;
%hookf(bool, _UIEventHasEdgePendingOrLocked, UITouchesEvent *event) {
	return hasEdgePendingOrLocked(event);
}

%end

%group FrontBoardFunction

bool (*FBUIEventHasEdgePendingOrLocked)(UITouchesEvent *) = NULL;
%hookf(bool, FBUIEventHasEdgePendingOrLocked, UITouchesEvent *event) {
	return hasEdgePendingOrLocked(event);
}

%end

/*%hook _FBSystemGestureManager

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gesture2 {
	BOOL orig = %orig(gesture1, gesture2);
	// gesture1: FBExclusiveTouchGestureRecognizer
	// gesture2: UIScreenEdgePanGestureRecognizer
	// will 0
	HBLogInfo(@"%d %@ | %@", orig, gesture1, gesture2);
	return orig;
}

%end*/

%group SharingHUD

%hook PNPChargingStatusView

- (void)updateChargingState:(NSInteger)state {
	%orig;
	if (state == 3) [self beginPairing];
}

%end

%end

void initPrefs(BOOL SB) {
	//dlopen("/Library/Frameworks/Cephei.framework/Cephei", RTLD_LAZY);
	/*preferences = [[%c(HBPreferences) alloc] initWithIdentifier:tweakIdentifier];
    [preferences registerBool:&enabled default:YES forKey:@"enabled"];
	if (SB) {
		[preferences registerObject:&quickNoteAppID default:@"xyz.willy.Zebra" forKey:@"quickNoteAppID"];
	}*/
}

%ctor {
	if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.Sharing.SharingHUDService"]) {
		dlopen("/System/Library/PrivateFrameworks/PencilPairingUI.framework/PencilPairingUI", RTLD_LAZY);
		%init(SharingHUD);
	}
	else if (isTarget(TargetTypeApps)) {
		void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
		if (IOKit) {
			_IOHIDEventGetChildren = (CFArrayRef (*)(IOHIDEventRef))dlsym(IOKit, "IOHIDEventGetChildren");
			_IOHIDEventGetType = (IOHIDEventType (*)(IOHIDEventRef))dlsym(IOKit, "IOHIDEventGetType");
			_IOHIDEventGetIntegerValue = (CFIndex (*)(IOHIDEventRef, IOHIDEventField))dlsym(IOKit, "IOHIDEventGetIntegerValue");
		}
		if (IN_SPRINGBOARD) {
			MSImageRef fb = MSGetImageByName("/System/Library/PrivateFrameworks/FrontBoard.framework/FrontBoard");
			FBUIEventHasEdgePendingOrLocked = (bool (*)(UITouchesEvent *))_PSFindSymbolCallable(fb, "__FBUIEventHasEdgePendingOrLocked");
			if (FBUIEventHasEdgePendingOrLocked) {
				%init(FrontBoardFunction);
			}
			MSImageRef uc = MSGetImageByName("/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore");
			_UIEventHasEdgePendingOrLocked = (bool (*)(UITouchesEvent *))_PSFindSymbolCallable(uc, "__UIEventHasEdgePendingOrLocked");
			if (_UIEventHasEdgePendingOrLocked) {
				%init(UIKitFunction);
			}
			/*MSImageRef sb = MSGetImageByName("/System/Library/PrivateFrameworks/SpringBoard.framework/SpringBoard");
			SBWorkspaceActivateApplicationFromURL = (void (*)(NSURL *, uint8_t, void (^)(SBMainWorkspaceTransitionRequest *)))_PSFindSymbolCallable(sb, "_SBWorkspaceActivateApplicationFromURL");
			SBWorkspaceApplicationCanLaunchWhilePasscodeLocked = (BOOL (*)(SBApplication *))_PSFindSymbolCallable(sb, "_SBWorkspaceApplicationCanLaunchWhilePasscodeLocked");
			if (SBWorkspaceApplicationCanLaunchWhilePasscodeLocked) {
				%init(SBWorkspace);
			}*/
			%init(SpringBoard);
			//_PSHookFunctionCompat("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", "_SBSSecureAppTypeForIdentifier", SBSSecureAppTypeForIdentifier);
			//_PSHookFunctionCompat("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", "_SBSIdentifierForSecureAppType", SBSIdentifierForSecureAppType);
		}
		initPrefs(YES);
		%init;
	}
}