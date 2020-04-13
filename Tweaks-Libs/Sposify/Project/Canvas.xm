#import <UIKit/UIWindow+Private.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <objc/runtime.h>
#import <CoreMedia/CoreMedia.h>
#include "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ColorForHex.h"
#import "SettingsViewController.h"

static NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

NSString *SpotifyVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; 

@interface SPTVideoDisplayView : UIView
- (AVQueuePlayer *)player;
@end

void saveVideoFromAVQueue(AVQueuePlayer *displayView){
  AVPlayerItem *currentVideo = [[displayView items] objectAtIndex:0];
  NSURL *videoURL = [currentVideo valueForKey:@"URL"];

  UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  while (topRootViewController.presentedViewController)
  {
    topRootViewController = topRootViewController.presentedViewController;
  }

[%c(SPTProgressView) showGaiaContextMenuProgressViewWithTitle:@"Saved Canvas to Photos."];
  ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];



  if ([prefs valueForKey:@"albumToSaveTo"]){
    NSString *savedValue = [prefs stringForKey:@"albumToSaveTo"];
    [library saveVideo:videoURL toAlbum:savedValue completion:nil failure:nil];
  }else{
    [library saveVideo:videoURL toAlbum:@"Canvas" completion:nil failure:nil];
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
  }
}


%hook SPTVideoDisplayView

%new
-(void)gestureHandler:(UISwipeGestureRecognizer *)gesture
{
  if (gesture.state == UIGestureRecognizerStateEnded) {

   }else if (gesture.state == UIGestureRecognizerStateBegan){
     saveVideoFromAVQueue([self player]);
  }
}


- (void)setPlayer:(id)arg1{
  %orig();
  UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
  [longPressGesture setMinimumPressDuration:0.4];
  [self addGestureRecognizer:longPressGesture];

}

%end
