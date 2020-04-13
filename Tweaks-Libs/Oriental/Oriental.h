#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIWindow+Private.h>

@interface CAPackage : NSObject
+ (id)packageWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id)arg4;
@end

@interface CCUICAPackageView : UIView
@property (nonatomic, retain) CAPackage *package;
- (void)setStateName:(id)arg1;
@end

@interface SBOrientationLockManager : NSObject
+ (id)sharedInstance;
- (void)unlock;
- (void)lock;
- (BOOL)isUserLocked;
@end