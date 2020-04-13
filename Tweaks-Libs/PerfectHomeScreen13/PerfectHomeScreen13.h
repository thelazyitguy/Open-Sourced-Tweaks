@interface SBIconProgressView: UIView
@property(nonatomic, strong) UILabel *_Nullable progressLabel;
@property(nonatomic, strong) UIView *_Nullable progressBar;
@property(nonatomic, assign) double displayedFraction;
@end

@interface SBSApplicationShortcutItem: NSObject
@property(nonatomic, retain) NSString *_Nullable type;
@end

@interface SBFolderController
- (void)_closeFolderTimerFired;
- (BOOL)isOpen;
@end

@interface SBHIconManager: NSObject
- (SBFolderController *_Nullable)openedFolderController;
@end

@interface SBApplicationIcon: NSObject
- (NSString *_Nullable)applicationBundleID;
@end

@interface SBIconListGridLayoutConfiguration
@property(nonatomic, assign) NSString *_Nullable location;
- (NSString *_Nullable)findLocation;
@end

@interface SBHIconViewContextMenuWrapperViewController : UIViewController
@end

@interface _UICutoutShadowView : UIView
@end