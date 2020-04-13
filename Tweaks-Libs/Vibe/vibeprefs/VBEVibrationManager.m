#import "VBEVibrationManager.h"

@implementation VBEVibrationManager
- (id)init {
    if((self = [super init])) {
        _settings = [[NSUserDefaults alloc] initWithSuiteName:@"com.gilesgc.vibe"];
    }

    return self;
}

- (void)vibrationPickerViewController:(id)arg1 selectedVibrationWithIdentifier:(id)arg2 {
    [self saveVibrationIdentifierToCurrentBundle:arg2];
}

- (void)saveVibrationIdentifierToCurrentBundle:(NSString *)vibrationIdentifier {
    [_settings setObject:vibrationIdentifier forKey:[self currentBundle]];
    [_settings synchronize];
}

- (NSString *)vibrationIdentifierForBundle:(NSString *)bundleIdentifier {
    return [_settings stringForKey:bundleIdentifier];
}
@end