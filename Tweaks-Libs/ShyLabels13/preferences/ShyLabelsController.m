#include "ShyLabelsController.h"
#import <spawn.h>

@implementation ShyLabelsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem = applyButton;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }

    return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];
    CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }
}

- (void)paypal {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/noisyflake"] options:@{} completionHandler:nil];
}

- (void)kofi {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ko-fi.com/ConorTheDev"] options:@{} completionHandler:nil];
}

- (void)respring {
    pid_t pid;
    const char *args[] = {"killall", "-9", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
}

@end

@implementation ShyLabelsLogo

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Banner" specifier:specifier];
    if (self) {
        CGFloat width = 320;
        CGFloat height = 70;

        CGRect backgroundFrame = CGRectMake(-50, -35, width + 50, height);
        background = [[UILabel alloc] initWithFrame:backgroundFrame];
        [background layoutIfNeeded];
        background.backgroundColor = [UIColor colorWithRed:0.35 green:0.78 blue:0.98 alpha:1.0];
        background.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        CGRect tweakNameFrame = CGRectMake(0, -40, width, height);
        tweakName = [[UILabel alloc] initWithFrame:tweakNameFrame];
        [tweakName layoutIfNeeded];
        tweakName.numberOfLines = 1;
        tweakName.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        tweakName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.0f];
        tweakName.textColor = [UIColor whiteColor];
        tweakName.text = @"ShyLabels13";
        // tweakName.backgroundColor = [UIColor colorWithRed:0.30 green:0.85 blue:0.39 alpha:1.0];
        tweakName.textAlignment = NSTextAlignmentCenter;

        CGRect versionFrame = CGRectMake(0, -5, width, height);
        version = [[UILabel alloc] initWithFrame:versionFrame];
        version.numberOfLines = 1;
        version.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        version.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        version.textColor = [UIColor whiteColor];
        version.text = @"Version 1.2";
        version.backgroundColor = [UIColor clearColor];
        version.textAlignment = NSTextAlignmentCenter;

        [self addSubview:background];
        [self addSubview:tweakName];
        [self addSubview:version];
    }
    return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    return 100.0f;
}
@end
