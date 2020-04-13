#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"

// Preferences
HBPreferences *prefs;
NSDictionary* prefsDict;

// Switches defaults states
BOOL enabled = YES;

// Color definitions
NSString* timeNetworkLTEColorValue = @"#147dfb";
NSString* batteryBodyColorValue = @"#147dfb";
NSString* batteryFillColorValue = @"#147dfb";
NSString* LTESignalActiveColorValue = @"#147dfb";
NSString* LTESignalInactiveColorValue = @"#1417fb";
NSString* WiFiActiveColorValue = @"#147dfb";
NSString* WiFiInactiveColorValue = @"#1417fb";
NSString* otherGlyphsColorValue = @"#147dfb";

// Interfaces
@interface _UIStatusBarPersistentAnimationView : UIView
@end

@interface _UIStatusBarSignalView : _UIStatusBarPersistentAnimationView
@property (nonatomic, copy) UIColor *inactiveColor;
@property (nonatomic, copy) UIColor *activeColor;
@end

@interface _UIStatusBarCellularSignalView : _UIStatusBarSignalView
@end

@interface _UIStatusBarWifiSignalView : _UIStatusBarSignalView
@end

@interface _UIStatusBarImageView : UIImageView
@property (nonatomic, retain) UIColor *tintColor;
@end

@interface _UIStatusBarStringView : UILabel
@end

@interface UIImageView (SBColors)
-(id)_viewControllerForAncestor;
@end

@interface UILabel (SBColors)
-(id)_viewControllerForAncestor;
@end

@interface _UIBatteryView : UIView
@property (nonatomic, copy) UIColor *bodyColor;
@property (nonatomic, copy) UIColor *fillColor;
@end

@interface _UIStaticBatteryView : _UIBatteryView
@end
