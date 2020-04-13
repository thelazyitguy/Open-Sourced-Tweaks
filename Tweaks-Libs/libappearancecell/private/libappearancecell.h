#define SYSTEM_VERSION_EQUAL_TO(v)                                             \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:v                                                               \
       options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                                         \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:v                                                               \
       options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)                             \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:v                                                               \
       options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                                            \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:v                                                               \
       options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)                                \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:v                                                               \
       options:NSNumericSearch] != NSOrderedDescending)

@interface NSUserDefaults (Private)
- (instancetype)_initWithSuiteName:(NSString *)suiteName
                         container:(NSURL *)container;
@end