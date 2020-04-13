#import "TKVibrationPickerViewController.h"

@interface VBEVibrationManager : NSObject <TKVibrationPickerViewControllerDelegate>
@property (nonatomic, retain) NSString *currentBundle;
@property (nonatomic, retain) NSUserDefaults *settings;

- (void)vibrationPickerViewController:(id)arg1 selectedVibrationWithIdentifier:(id)arg2;
- (void)saveVibrationIdentifierToCurrentBundle:(NSString *)vibrationIdentifier;
- (NSString *)vibrationIdentifierForBundle:(NSString *)bundleIdentifier;
@end