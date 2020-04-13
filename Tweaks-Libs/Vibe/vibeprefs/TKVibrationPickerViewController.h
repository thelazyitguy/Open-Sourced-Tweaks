@protocol TKVibrationPickerViewControllerDelegate <NSObject>
@optional
- (void)vibrationPickerViewController:(id)arg1 selectedVibrationWithIdentifier:(id)arg2;
@end

@interface TKVibrationPickerViewController : UIViewController
@property (nonatomic, weak, readwrite) id<TKVibrationPickerViewControllerDelegate> delegate;
- (void)setSelectedVibrationIdentifier:(NSString *)vibrationIdentifier;
- (void)setDefaultVibrationIdentifier:(NSString *)identifier;
@end