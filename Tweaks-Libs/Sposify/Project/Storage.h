#import <UIKit/UIKit.h>

@interface Storage : NSObject

+ (instancetype)sharedStorage;
- (void)addPackageID:(NSNumber *)packageID;
- (BOOL)containsPackageID:(NSNumber *)packageID;
- (void)synchronize;

@end
