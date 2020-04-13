#import "CCRinger13.h"

@implementation CCRinger13

//Return the icon of your module here
- (UIImage *)iconGlyph {
    return [UIImage imageNamed:@"bell" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

//Return the color selection color of your module here
- (UIColor *)selectedColor {
    return [UIColor redColor];
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    [super refreshState];

    if (_selected) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.ccringer13/muteringer"), NULL, NULL, YES);
    } else {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.ccringer13/unmuteringer"), NULL, NULL, YES);
    }
}

@end
