//
// HPManager.m
// HomePlus
//
// Data Manager
//
// This class is kind of gutted from its former self
// Needs cleaned up for the stuff it handles now
//
// Created Oct 2019
// Author: Kritanta
//

#include "HPManager.h"
#include "HomePlus.h"
#include "HPMonitor.h"

@implementation HPManager

+ (instancetype)sharedManager
{
    static HPManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];

    if (self) {
        [self loadSavedCurrentLoadoutName];
        [self loadCurrentLoadout];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];
    }

    return self;
}

- (void)recieveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:kEditingModeEnabledNotificationName]) {
        [self loadCurrentLoadout]; // do both
    } else {
        [self saveCurrentLoadout];
    }
}
- (void)saveCurrentLoadoutName
{
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentLoadoutName
                                               forKey:@"HPCurrentLoadout"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadSavedCurrentLoadoutName
{
    //[[NSUserDefaults standardUserDefaults] synchronize];
    self.currentLoadoutName = [[NSUserDefaults standardUserDefaults] stringForKey:@"HPCurrentLoadout"] ?: @"Default";
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCurrentLoadout
{
    self.useUserDefaults = YES;
    if (self.useUserDefaults)
        [self saveLoadoutToUserDefaults:self.currentLoadoutName];
    //else
        //[self saveLoadoutToFilesystem:self.currentLoadoutName];
}

- (void)loadCurrentLoadout
{
    self.useUserDefaults = YES;
}

-(id)loadConfigFromFilesystem:(NSString *)name 
{   
    self.vRowUpdates = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPvRowUpdates"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPvRowUpdates"]
                                        : YES;
    self.switcherDisables = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPswitcherDisables"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPswitcherDisables"]
                                        : YES;
    self.useUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPuseUserDefaults"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPuseUserDefaults"]
                                        : YES;
    self.dockConfigEnabled = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPdockEditingEnabled"] 
                                    ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPdockEditingEnabled"]
                                    : YES;
    return nil;
}

- (id)loadConfigFromUserDefaultSystem:(NSString *)name
{
    self.vRowUpdates = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPvRowUpdates"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPvRowUpdates"]
                                        : YES;
    self.switcherDisables = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPswitcherDisables"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPswitcherDisables"]
                                        : YES;
    self.useUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPuseUserDefaults"] 
                                        ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPuseUserDefaults"]
                                        : YES;
    self.dockConfigEnabled = [[NSUserDefaults standardUserDefaults] objectForKey:@"HPdockEditingEnabled"] 
                                    ? [[NSUserDefaults standardUserDefaults] boolForKey:@"HPdockEditingEnabled"]
                                    : YES;
    return nil;
}

- (void)saveLoadoutToUserDefaults:(NSString *)name 
{

}

- (NSMutableDictionary *)createDictionaryDefaultStructure
{
    [[HPMonitor sharedMonitor] logItem:@"Retrieving Default Loadout Scheme"];
    NSMutableDictionary *rootFolderDefaultsPageZero = [@{
        @"topOffset" : @0.0,
        @"leftOffset": @0.0,
        @"verticalSpacing": @0.0,
        @"horizontalSpacing": @0.0,
        @"iconSize": @60.0,
        @"iconRotation": @0.0,
        @"rows": @5,
        @"columns":@4
    } mutableCopy];
    NSMutableDictionary *dockDefaults = [@{
        @"topOffset" : @0.0,
        @"leftOffset": @0.0,
        @"verticalSpacing": @0.0,
        @"horizontalSpacing": @0.0,
        @"iconSize": @60.0,
        @"iconRotation": @0.0,
        @"rows": @1,
        @"columns": @4,
        @"bg":@NO
    } mutableCopy];
    NSMutableDictionary *floatyFolderDefaults = [@{
        @"topOffset" : @0.0,
        @"leftOffset": @0.0,
        @"verticalSpacing": @0.0,
        @"horizontalSpacing": @0.0,
        @"iconSize": @60.0,
        @"iconRotation": @0.0,
        @"rows": @3,
        @"columns": @3,
        @"iconbg":@NO
    } mutableCopy];
    NSMutableDictionary *defaultDictionaryStructure = [@{
        @"valuesInitialized": @NO,
        @"switcherDisables": @YES,
        @"vRowUpdates": @YES,
        // The 0 after root indicates page
        // 0 will be the default loadout.
        @"SBIconLocationRoot0":rootFolderDefaultsPageZero,
        @"SBIconLocationDock":dockDefaults,
        @"SBIconLocationFolder":floatyFolderDefaults
    } mutableCopy];
    return defaultDictionaryStructure;
}

- (void)resetCurrentLoadoutToDefaults
{
}

@end

