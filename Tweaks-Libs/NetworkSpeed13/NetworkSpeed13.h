@interface SBCoverSheetPresentationManager: NSObject
+ (id)sharedInstance;
- (BOOL)isPresented;
@end

@interface NetworkSpeed: NSObject
{
    UIWindow *networkSpeedWindow;
    UILabel *networkSpeedLabel;
}
- (id)init;
- (void)updateOrientation;
- (void)updateFrame;
- (void)updateNetworkSpeedSize;
- (void)updateTextColor:(UIColor *)color;
@end

@interface UIWindow ()
- (void)_setSecure:(BOOL)arg1;
@end

@interface UIApplication ()
- (UIDeviceOrientation)_frontMostAppOrientation;
@end

@interface _UIStatusBarStyleAttributes : NSObject
@property(nonatomic, copy) UIColor *imageTintColor;
@end

@interface _UIStatusBar : UIView
@property(nonatomic, retain) _UIStatusBarStyleAttributes *styleAttributes;
@end