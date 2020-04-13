
#define MSHBarView MSHBarView
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "MSHBarView.h"
#define kIdentifier @"me.kritanta.statusvizprefs"
#define kSettingsChangedNotification (CFStringRef)@"me.kritanta.statusvizprefs/Prefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.kritanta.statusvizprefs.plist"

@interface _UIStatusBarStringView : UIView 
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@end
@interface _UIStatusBarForegroundView : UIView 
@property (nonatomic, assign) BOOL kek;
@property (nonatomic, retain) MSHBarView *mshView;
@property (nonatomic, retain) MSHBarView *mshShitHackView;
@property (nonatomic, retain) MSHBarView *mshBackView;
@property (nonatomic, retain) MSHBarView *mshBackTwoView;
@end

// _UIStatusBar 
@interface Its3AMAndIAmCravingTacoBell : UIView
// 0 = main screen, 1 = CC 
@property (nonatomic, assign) NSInteger mode;
@end

@interface  MPUNowPlayingController : NSObject
- (void)startUpdating;
- (id)currentNowPlayingArtwork;
+ (id)currentArtwork;
@property (nonatomic, retain) NSString *currentNowPlayingArtworkDigest;
@end
