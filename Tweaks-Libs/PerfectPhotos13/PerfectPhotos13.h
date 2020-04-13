@interface PUOneUpViewController : UIViewController
- (id _Nullable)pu_debugCurrentAsset;
@end

@interface PUNavigationController
- (UIViewController *_Nullable)_currentToolbarViewController;
@end

@interface PHAsset : NSObject
- (CGSize)imageSize;
- (id _Nullable)mainFileURL;
@end

@interface PUPhotoBrowserTitleViewController : UIViewController
- (void)_setNeedsUpdate;
@end
