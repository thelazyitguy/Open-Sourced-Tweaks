//
// ExtensionManager.m
// HomePlus
//
// Global manager for the Extension Framework
//
// Maybe at some point this should be refactored to HPExtensionManager
//
// Authors: Kritanta
// Created  Dec 2019
//

#include "ExtensionManager.h"
#include "HPExtensionControllerView.h"

@implementation ExtensionManager


+ (instancetype)sharedManager
{
    static ExtensionManager *sharedManager = nil;
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
        self.extensions = [[NSMutableArray alloc] init];
        [self findAndLoadInExtensions];
    }

    return self;
}

- (void)findAndLoadInExtensions
{
    NSArray<NSString *> *listOfPrefBundles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/PreferenceBundles" error:nil];
    for (NSString *bundle in listOfPrefBundles)
    {
        //NSLog(@"HomePlusEM: %@", bundle);
        NSString *ting = [NSString stringWithFormat:@"%@%@",@"/Library/PreferenceBundles/", bundle];
        //NSLog(@"HomePlusEM: t %@", ting);
        NSArray<NSString *> *listOfBundleContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ting error:nil];
        for (NSString *item in listOfBundleContents)
        {
            //NSLog(@"HomePlusEM: i %@", item);
            if ([item isEqualToString:@"HomePlus.plist"])
            {
                // Found a HomePlus Extension List!
                //NSLog(@"HomePlusEM: Found an extension");
                [self loadExtensionFromBundle:ting];
            }
        }
    }
}

- (void)loadExtensionFromBundle:(NSString *)bundlePath
{
    //NSLog(@"HomePlusEM: Loading ext from bundle %@", bundlePath);
    NSString *extensionPath = [NSString stringWithFormat:@"%@%@", bundlePath, @"/HomePlus.plist"];
    NSMutableDictionary *extensionDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:extensionPath];
    HPExtension *extension = [[HPExtension alloc] initWithDictionary:extensionDictionary atBundlePath:bundlePath];
    [self.extensions addObject:extension];
}

@end
