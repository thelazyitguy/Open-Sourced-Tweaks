@interface SBUIBiometricResource: NSObject
+ (id)sharedInstance;
- (void)noteScreenDidTurnOff;
- (void)noteScreenWillTurnOn;
@end

@interface MRPlatterViewController: UIViewController
@end

@interface SBUIFlashlightController: NSObject
+ (id)sharedInstance;
- (NSInteger)level;
@end

@interface SBCoverSheetPanelBackgroundContainerView: UIView
- (void)_setCornerRadius: (double)arg1;
@end

@interface UIScreen ()
- (double)_displayCornerRadius;
@end