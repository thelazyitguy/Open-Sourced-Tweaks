//
// ExtensionManager.h
// HomePlus
//
// Global manager for the Extension Framework
//
// Maybe at some point this should be refactored to HPExtensionManager
//
// Authors: Kritanta
// Created  Dec 2019
//

@interface ExtensionManager : NSObject 

@property (nonatomic, retain) NSMutableArray *extensions;

+ (instancetype)sharedManager;
- (instancetype)init;

- (void)findAndLoadInExtensions;

@end