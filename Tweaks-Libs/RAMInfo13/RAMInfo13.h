@interface SBCoverSheetPresentationManager: NSObject
+ (id)sharedInstance;
- (BOOL)isPresented;
@end

@interface RamInfo: NSObject
{
    UIWindow *ramInfoWindow;
    UILabel *ramInfoLabel;
}
- (id)init;
- (void)updateOrientation;
- (void)updateFrame;
- (void)updateRAMInfoSize;
- (void)updateText;
- (void)updateTextColor: (UIColor*)color;
@end

@interface UIWindow ()
- (void)_setSecure: (BOOL)arg1;
@end

@interface UIApplication ()
- (UIDeviceOrientation)_frontMostAppOrientation;
@end

@interface _UIStatusBarStyleAttributes: NSObject
@property(nonatomic, copy) UIColor *imageTintColor;
@end

@interface _UIStatusBar: UIView
@property(nonatomic, retain) _UIStatusBarStyleAttributes *styleAttributes;
@end