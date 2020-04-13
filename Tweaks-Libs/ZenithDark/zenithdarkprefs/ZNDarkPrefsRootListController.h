#import <Preferences/PSListController.h>
@import UIKit;

// image for share button

#define kImagePath @"/Library/Application Support/ZenithDark/ZNDark.png"

@interface ZNDarkPrefsRootListController : PSListController
@property (nonatomic, strong) UIBlurEffect *respringBlur;
@property (nonatomic, strong) UIVisualEffectView *respringEffectView;
@property (nonatomic, strong) UIWindow *mainAppRootWindow;
@end


// we use this to respring our device!
@interface NSTask : NSObject
@property (copy) NSArray *arguments;
@property (copy) NSString *currentDirectoryPath;
@property (copy) NSDictionary *environment;
@property (copy) NSString *launchPath;
@property (readonly) int processIdentifier;
@property (retain) id standardError;
@property (retain) id standardInput;
@property (retain) id standardOutput;
+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;
- (id)init;
- (void)interrupt;
- (bool)isRunning;
- (void)launch;
- (bool)resume;
- (bool)suspend;
- (void)terminate;
@end
