#import "LockWidgetsUtils.h"
#import "LockWidgetsView.h"

@interface LockWidgetsConfig : NSObject
@property (nonatomic, retain) NSArray *selectedWidgets;
@property (nonatomic, retain) NSDictionary *preferences;
@property (nonatomic) bool enabled;
@property (nonatomic) bool reachabilityEnabled;
@property (nonatomic) bool hideWhenLocked;

+ (instancetype)sharedInstance;
- (id)init;

- (void)reloadPreferences;
- (void)saveValues;
- (BOOL)writeValue:(NSObject *)value forKey:(NSString *)key;
@end