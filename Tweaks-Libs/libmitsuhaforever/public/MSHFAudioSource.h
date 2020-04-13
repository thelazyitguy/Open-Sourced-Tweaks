#import "MSHFAudioDelegate.h"

@interface MSHFAudioSource : NSObject

@property(nonatomic, assign) bool isRunning;
@property(nonatomic, retain) id<MSHFAudioDelegate> delegate;

- (id)init;
- (void)start;
- (void)stop;

@end