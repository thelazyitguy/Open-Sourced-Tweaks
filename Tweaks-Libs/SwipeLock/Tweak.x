#import <UIKit/UIKit.h>

@interface SpringBoard : NSObject
- (void)_simulateLockButtonPress;
@end

@interface SBHomeScreenViewController : UIViewController
@end

static void lockDevice() {
    [((SpringBoard *)[%c(SpringBoard) sharedApplication]) 
_simulateLockButtonPress];
}

%hook SBHomeScreenViewController

-(void)loadView {
	%orig;

	UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
	swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer:swipeUp];
}

%new
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
	lockDevice();
}

%end