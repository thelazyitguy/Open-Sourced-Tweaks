#import <UIKit/UIKit.h>
#import "HPMonitor.h"

#define kEditingModeChangedNotificationName @"HomePlusEditingModeChanged"
#define kEditingModeEnabledNotificationName @"HomePlusEditingModeEnabled"
#define kEditingModeDisabledNotificationName @"HomePlusEditingModeDisabled"
#define kEditorKickViewsUp @"HomePlusKickWindowsUp"
#define kEditorKickViewsBack @"HomePlusKickWindowsBack"
#define kDeviceIsLocked @"HomePlusDeviceIsLocked"
#define kDeviceIsUnlocked @"HomePlusDeviceIsUnlocked"
#define kWiggleActive @"HomePlusWiggleActive"
#define kWiggleInactive @"HomePlusWiggleInactive"
#define kDisableWiggleTrigger @"HomePlusDisableWiggle"
#define kHighlightViewNotificationName @"HomePlusHighlightRelevantView"
#define kFadeFloatingDockNotificationName @"HomePlusFadeFloatingDock"
#define kShowFloatingDockNotificationName @"HomePlusShowFloatingDock"
#define kReloadIconScaleNotificationName @"HomePlusReloadIconScale"

#define kMonitorEnabled NO

@implementation HPMonitor

+ (instancetype)sharedMonitor 
{
    static HPMonitor *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];

    if (self && kMonitorEnabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kDeviceIsLocked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kDeviceIsUnlocked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kDisableWiggleTrigger object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeChangedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditorKickViewsBack object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditorKickViewsUp object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kFadeFloatingDockNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kHighlightViewNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kReloadIconScaleNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kShowFloatingDockNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kWiggleActive object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kWiggleInactive object:nil];
    }

    return self;
}

- (void)recieveNotification:(NSNotification *)notification
{
    if (kMonitorEnabled) NSLog(@"HomePlus Monitor - Notification Called: %@", [notification name]);
}
- (void)logItem:(NSString *)item
{
    if (kMonitorEnabled) NSLog(@"HomePlus Monitor: %@", item);
}
@end