#define kBundlePath @"/var/mobile/Library/com.johnzaro.AppStoreUpdatesTab13.bundle"

static NSBundle *bundle;

@interface UITabBarButtonLabel : UILabel
- (NSString *)text;
- (void)setText:(NSString *)arg1;
@end

@interface UITabBarButton : UIControl
- (void)setImage:(id)arg1;
- (void)_setCustomSelectedIndicatorImage:(id)arg1;
@end

@interface UITabBarSwappableImageView : UIImageView
@end
