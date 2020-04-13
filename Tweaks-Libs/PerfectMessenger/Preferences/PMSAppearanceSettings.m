#import "PMSRootListController.h"

@implementation PMSAppearanceSettings

- (UIColor*)tintColor
{
    return [UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0];
}

- (UIColor*)statusBarTintColor
{
    return [UIColor blackColor];
}

- (UIColor*)navigationBarTitleColor
{
    return [UIColor blackColor];
}

- (UIColor*)navigationBarTintColor
{
    return [UIColor blackColor];
}

- (UIColor*)tableViewCellSeparatorColor
{
    return [UIColor colorWithWhite:0 alpha:0];
}

- (UIColor*)navigationBarBackgroundColor
{
    return [UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0];
}

- (UIColor*)tableViewCellTextColor
{
    return [UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0];
}

- (BOOL)translucentNavigationBar
{
    return NO;
}

- (NSUInteger)largeTitleStyle
{
    return 2;
}

@end