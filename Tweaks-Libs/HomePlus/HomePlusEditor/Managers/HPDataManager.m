//
// HPDataManager.m
// HomePlus
//
// Global manager for Data used in HomePlus
//
// Authors: Kritanta
// Created  Dec 2019
//

#include "HPDataManager.h"

@implementation HPDataManager


+ (instancetype)sharedManager
{
    static HPDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}


- (instancetype)init
{
    self = [super init];

    if (self) 
    {
        self.savedConfigurations = [[NSMutableArray alloc] init];
        [self loadListOfSavedConfigurations];
        NSString *configName = [[NSUserDefaults standardUserDefaults] stringForKey:@"HPCurrentLoadout"] ?: @"Default";
        [self loadConfigurationWithName:configName];
    }

    return self;
}

- (void)loadListOfSavedConfigurations
{
    NSArray<NSString *> *listOfConfigurations = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/HomePlus/Loadouts" error:nil];
    for (NSString *bundle in listOfConfigurations)
    {
        if ([bundle containsString:@".plist"])
        {
            [self.savedConfigurations addObject:[[HPConfiguration alloc] initWithConfigurationName:bundle]];
        }
    }
}

- (void)loadConfigurationWithName:(NSString *)name
{
    if (![name containsString:@".plist"])
    {
        name = [NSString stringWithFormat:@"%@%@", name, @".plist"];
    }

    self.currentConfiguration = [[HPConfiguration alloc] initWithConfigurationName:name];
}

@end