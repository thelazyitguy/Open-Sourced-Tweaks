#import <SpringBoard/SBFolderView.h>
#import <SpringBoard/SBIcon.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconView.h>
#import <SpringBoard/SBIconViewMap.h>

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface SBFolderView (ShyPageDots)
- (void)_prepareHideLabels;
- (void)_hideLabels;
- (void)_showLabels;
@end

@interface SBIconView (ShyCons)
- (void)setIconLabelAlpha:(float)alpha;
@end

@interface SBIconViewMap (ShyCons)
- (id)mappedIconViewForIcon:(id)icon;
@end

@interface SBIconListView : UIView
- (id)icons;
@end

@interface SBRootFolderView
- (SBIconListView *)currentIconListView;
@end

@interface SBRootFolderController
- (SBRootFolderView *)rootFolderView;
@end

@interface SBIconController (ShyCons)
- (SBRootFolderController *)rootFolderController;
@end

@interface SBRootIconListView
- (id)icons;
- (id)viewMap;
@end

static void animateIconLabelAlpha(double alpha, int version);
