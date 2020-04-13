#include "HPConfiguration.h"

@interface HPDataManager : NSObject 

+ (instancetype)sharedManager;

@property (nonatomic, retain) HPConfiguration *currentConfiguration;

@property (nonatomic, retain) NSMutableArray *savedConfigurations;

@end