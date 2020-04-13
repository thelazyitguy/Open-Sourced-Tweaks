#import <UIKit/UIKit.h>

@interface HPMonitor : NSObject

+ (instancetype)sharedMonitor;

-(void)logItem:(NSString *)info;

@end
