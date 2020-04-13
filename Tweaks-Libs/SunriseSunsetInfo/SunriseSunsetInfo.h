@interface SBCoverSheetPresentationManager: NSObject
+ (id)sharedInstance;
- (BOOL)isPresented;
@end

@interface SunriseSunsetInfo: NSObject
{
    UIWindow *sunriseSunsetInfoWindow;
    UILabel *sunriseSunsetInfoLabel;
}
- (id)init;
- (void)updateOrientation;
- (void)updateFrame;
- (void)updateSunriseSunsetInfoSize;
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

@interface WeatherPreferences: NSObject
+ (id)sharedPreferences;
@end

@interface WAForecastModel: NSObject
- (NSDate *)sunrise;
- (NSDate *)sunset;
@end

@interface WATodayModel: NSObject
+ (id)autoupdatingLocationModelWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2;
- (WAForecastModel *)forecastModel;
@end
