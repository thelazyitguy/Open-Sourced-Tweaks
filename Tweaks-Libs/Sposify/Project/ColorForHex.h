@interface UIColor(Hexadecimal)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

@interface UIImage (SPT)
+ (id)imageForSPTIcon:(NSInteger)icon size:(CGSize)size;
+ (id)imageForSPTIcon:(NSInteger)icon size:(CGSize)size color:(UIColor *)color;
+ (id)trackSPTPlaceholderWithSize:(NSInteger)size;
+ (id)spt_infoViewErrorIcon;
+ (id)spt_starImageForSPTIcon:(NSInteger)icon size:(CGSize)size;
+ (id)spt_imageWithColor:(id)arg1 size:(struct CGSize)arg2;
@end 

@interface RootSettingsViewController : UIViewController
@property (nonatomic, strong) UINavigationItem *navigationItem;
@end

/*
 * SPTProgressView modes:
 * 0: three dots
 * 1: checkmark
 * 2: cross
 */
typedef enum {
    SPTProgressViewDotsMode,
    SPTProgressViewCheckmarkMode,
    SPTProgressViewCrossMode
} SPTProgressViewMode;

@interface SPTProgressView : UIView
+(void)showGaiaContextMenuProgressViewWithTitle:(id)arg1;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) NSInteger mode;
+ (id)progressView;
- (void)animateShowing;
- (void)animateHiding;
@end

@interface SPTAlertPresenter : NSObject
+ (id)sharedInstance;
+ (id)defaultPresenterWithWindow:(id)arg;
- (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)msg actions:(NSArray *)actions;
- (void)queueAlertController:(UIAlertController *)alert;
- (void)showNextAlert;
@end

@interface SPTInfoView : UIView
@property (nonatomic, readwrite, assign) NSString *title;
@property (nonatomic, readwrite, assign) NSString *text;
@property (nonatomic, readwrite, assign) UIImage *image;
@end

@interface UINavigationController (SPT)
- (void)pushViewControllerOnTopOfTheNavigationStack:(UIViewController *)vc animated:(BOOL)animate;
@end

@interface SPTPopupDialog : UIViewController
+(id)popupWithTitle:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)buttonTitle;
+(id)popupWithTitle:(NSString *)title message:(NSString *)message buttons:(id)buttons;
-(void)dismissSelf;
@end

@interface SPTPopupButton : NSObject
+(id)buttonWithTitle:(NSString *)arg1;
+(id)buttonWithTitle:(NSString *)arg1 actionHandler:(id)arg2;
@end

@interface SPTPopupManager : NSObject
@property(nonatomic, readwrite, assign) NSMutableArray *presentationQueue;
+(SPTPopupManager *)sharedManager;
-(void)presentNextQueuedPopup;
@end