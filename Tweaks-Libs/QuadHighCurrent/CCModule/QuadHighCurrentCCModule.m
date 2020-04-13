#import "QuadHighCurrentCCModule.h"
#import <UIKit/UIColor+Private.h>

@implementation QuadHighCurrentCCModule

- (UIImage *)iconGlyph {
    return [UIImage imageNamed:@"icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (UIColor *)selectedColor {
    return [UIColor systemOrangeColor];
}

- (BOOL)isSelected {
    Boolean keyExist = NO;
    Boolean enabled = CFPreferencesGetAppBooleanValue(key, kDomain, &keyExist);
    return !keyExist ? NO : enabled;
}

- (void)setSelected:(BOOL)selected {
    [super refreshState];
    CFPreferencesSetAppValue(key, selected ? kCFBooleanTrue : kCFBooleanFalse, kDomain);
    CFPreferencesAppSynchronize(kDomain);
}

@end
