#import <liblockwidgets/LockWidgetsView.h>

@interface UIView (RemoveConstraints)

- (void)removeAllConstraints;

@end

@interface LockWidgetsManager : NSObject
@property (nonatomic, retain) LockWidgetsView *view;
+ (instancetype)sharedInstance;
- (id)init;
- (NSArray *)getAllWidgetIdentifiers;
@end

@interface WGWidgetDiscoveryController : NSObject
- (void)beginDiscovery;
- (id)visibleWidgetIdentifiersForGroup:(id)arg1;
- (id)enabledWidgetIdentifiersForAllGroups;
- (id)disabledWidgetIdentifiers;
@end

@interface UIImage (UIApplicationIconPrivate)
+ (id)_iconForResourceProxy:(id)arg1 format:(int)arg2;
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 roleIdentifier:(id)arg2 format:(int)arg3 scale:(float)arg4;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 roleIdentifier:(id)arg2 format:(int)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
+ (int)_iconVariantForUIApplicationIconFormat:(int)arg1 scale:(float *)arg2;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2 scale:(float)arg3;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2;
@end
