#import "CTDPrefs.h"

@implementation CTDPreferenceSettings
+ (instancetype)sharedInstance {
  static CTDPreferenceSettings *sharedInstance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [CTDPreferenceSettings alloc];
  });

  return sharedInstance;
}

- (id)init {
  return [CTDPreferenceSettings sharedInstance];
}
@end