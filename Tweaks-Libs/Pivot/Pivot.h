#include <UIKit/UIKit.h>

#define kIdentifier @"me.kritanta.pivot"
#define kSettingsChangedNotification (CFStringRef)@"me.kritanta.pivot/Prefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.kritanta.pivot.plist"

@interface SBRootFolderController : UIViewController
@property (nonatomic, assign) CGFloat dockHeight;
@end

@interface SBIconController : UIViewController
+ (SBIconController *)sharedInstance;
- (SBRootFolderController *)_rootFolderController;
@end

// bad



@interface SBRootIconListView : UIView

@property (nonatomic, retain) NSDictionary *managerValues;
@property (nonatomic, assign) CGFloat customTopInset;
@property (nonatomic, assign) CGFloat customLeftOffset;
@property (nonatomic, assign) CGFloat customSideInset;
@property (nonatomic, assign) CGFloat customVerticalSpacing;
@property (nonatomic, assign) CGFloat customRows;
@property (nonatomic, assign) CGFloat customColumns;
@property (nonatomic, assign) BOOL configured;
@property (nonatomic, assign) CGRect typicalFrame;
@property (nonatomic, retain) NSArray *allSubviews;

- (void)getLatestValuesFromManager;
- (NSString *)newIconLocation;
- (NSInteger)iconLocation;
- (CGFloat)horizontalIconPadding ;
- (void)setIconsLabelAlpha:(double)arg1;
- (void)updateTopInset:(CGFloat)arg1;
- (void)updateSideInset:(CGFloat)arg1;
- (void)resetValuesToDefaults;
- (void)updateVerticalSpacing:(CGFloat)arg1;
- (void)updateLeftOffset:(CGFloat)arg1;
- (void)recieveNotification:(NSNotification *)notification;
- (void)updateCustomRows:(CGFloat)arg1;
- (void)updateCustomColumns:(CGFloat)arg1;
- (NSUInteger)iconRowsForHomePlusCalculations;
- (void)layoutIconsNow;
- (CGFloat)sideIconInset;
- (CGFloat)verticalIconPadding;
- (CGFloat)topIconInset;
- (CGSize)defaultIconSize;
- (void)setLayoutReversed:(BOOL)arg;
- (void)updateRC;
- (NSUInteger)iconRowsForSpacingCalculation;
+ (NSUInteger)maxIcons;
+ (NSUInteger)iconRowsForInterfaceOrientation:(NSInteger)arg1;
+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1;

@end
