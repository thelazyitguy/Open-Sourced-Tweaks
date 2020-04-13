//
// Tweak.xm
// Fingertips
//
// Draw all touches within a window for screen recording/mockup purposes
//
// Credit to app framework:
// https://github.com/mapbox/Fingertips
//
//
#include "libcolorpicker.h"
#include "MBFingerTipWindow.h"

// Declare ourselves a global to hit
static MBFingerTipWindow *_rtWindow;

%hook UIApplication

// This isn't likely the best method to hook, just a repurposed one, but it works :)
-(UIWindow *)keyWindow 
{
	UIWindow *o = %orig;
	if (!_rtWindow)
	{
		_rtWindow = [[MBFingerTipWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		// _rtWindow.overlayWindow isn't registering properly in every app; need to look at what can be done there. 
	} 	
    return o;
}

%end

%hook MBFingerTipOverlayWindow
//super hacky fix for showing our view on the lockscreen

- (BOOL)_shouldCreateContextAsSecure {
	UIColor *coolColor = LCPParseColorString(@"ffffff", @"#ff0000");
    return YES;
}

%end

// Hook every window. 
%hook UIWindow

- (void)sendEvent:(UIEvent *)event
{
	%orig;
	//if (self != [[UIApplication sharedApplication] keyWindow]) return;

	// Make sure we dont accidentally create an unending loop
	if (self==_rtWindow) return;

	// Now that the app has registered input, tell the window to draw the touch. 
	if (_rtWindow) [_rtWindow sendEvent:event];
}

%end