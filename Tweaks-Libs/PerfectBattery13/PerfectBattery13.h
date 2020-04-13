@interface _UIBatteryView : UIView
@property NSInteger chargingState;
@property CGFloat chargePercent;
@property BOOL saverModeActive;
@property(nonatomic, readwrite) UIColor *fillColor;
@property(nonatomic, retain) UIColor *backupFillColor;
@property(nonatomic, retain) UILabel *percentLabel;
- (void)updatePercentageColor;
@end

@interface _UIStaticBatteryView : _UIBatteryView
@end