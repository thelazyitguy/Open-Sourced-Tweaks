#import "Storage.h"

#define PACKAGE_IDS_KEY @"wxtrbosvnrlnd_25845"


@interface Storage()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *packageIdStorage;

@end


@implementation Storage

+ (instancetype)sharedStorage {
    static Storage *storage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[Storage alloc] init];
    });
    return storage;
}

- (void)addPackageID:(NSNumber *)packageID {
    if (!packageID) { return; }
    [self.packageIdStorage addObject:packageID];
}

- (BOOL)containsPackageID:(NSNumber *)packageID {
    if (!packageID) { return NO; }
    return [self.packageIdStorage containsObject:packageID];
}

- (void)synchronize {
    [self.userDefaults setObject:[self.packageIdStorage allObjects] forKey:PACKAGE_IDS_KEY];
    [self.userDefaults synchronize];
}

#pragma mark - Getters

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.sposify.client.userdefaults"];
    }
    return _userDefaults;
}

- (NSMutableSet<NSNumber *> *)packageIdStorage {
    if (!_packageIdStorage) {
        NSArray *array = [self.userDefaults objectForKey:PACKAGE_IDS_KEY];
        if (array) {
            _packageIdStorage = [NSMutableSet setWithArray:array];
        } else {
            _packageIdStorage = [NSMutableSet set];
        }
    }
    return _packageIdStorage;
}

@end
