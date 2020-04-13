// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

@interface MediaControlsHeaderView : UIView 
@property (nonatomic,retain) UIButton *routingButton; 
@property (assign,nonatomic) BOOL shouldUseOverrideSize;

- (void)layoutSubviews;
- (void)clearOverrideSize;
- (void)setOverrideSize:(CGSize)arg1 ;
- (UIButton *)routingButton;
- (void)setRoutingButton:(UIButton *)arg1 ;
- (BOOL)shouldUseOverrideSize;
@end

@interface MRPlatterViewController : UIViewController
@property (nonatomic,retain) UIView *routingCornerView; 
@property (nonatomic,retain) UIView *parentContainerView; /* This is song progress bar, previous, play / pause, next */
@property (nonatomic,retain) MediaControlsHeaderView* nowPlayingHeaderView; /* This is the top bar, so, artwork, title, artist, album and casting */

-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewWillDisappear:(BOOL)arg1 ;
-(void)viewDidLoad;

@end

#import "LockView.h"

%hook MediaControlsHeaderView
CGRect originalRouteRect;
LockView *padlockView;

- (UIButton *)routingButton {
	UIButton *origButton = %orig;
	id superDuperView = self.superview.superview.superview;
	if ([superDuperView isMemberOfClass:[NSClassFromString(@"CSMediaControlsView") class]]) {
		if (CGRectIsEmpty(originalRouteRect)) {
			originalRouteRect = origButton.frame;
		}
		CGRect newRouteFrame = CGRectMake(self.frame.size.width - originalRouteRect.size.width - 15, self.frame.size.height - originalRouteRect.size.height, originalRouteRect.size.width, originalRouteRect.size.height);
		origButton.frame = newRouteFrame;
	}
	return origButton;
}

- (void)setRoutingButton:(UIButton *)arg1 {
	%orig(arg1);
	id superDuperView = self.superview.superview.superview;
	if ([superDuperView isMemberOfClass:[NSClassFromString(@"CSMediaControlsView") class]]) {
		if (CGRectIsEmpty(originalRouteRect)) {
			originalRouteRect = arg1.frame;
		}
		CGRect newRouteFrame = CGRectMake(self.frame.size.width - originalRouteRect.size.width - 15, self.frame.size.height - originalRouteRect.size.height, originalRouteRect.size.width, originalRouteRect.size.height);
		arg1.frame = newRouteFrame;
	}
}

%end


%hook MRPlatterViewController

/*
self.nowPlayingHeaderView:
1x superview: UIView (generic).
2x: BoundsChangeAwareView
3x: CSMediaControlsView (at LS), UIScrollView otherwise. This allows us to distinguish and only show the tweak at the lock screen.
*/

LockView *padlockView;
CGFloat currentProgress;

-(void)viewWillAppear:(BOOL)arg1 {
	%orig(arg1);
	//The routing button is:
	UIButton *routeButton = self.nowPlayingHeaderView.routingButton;
	
	id superDuperView = self.nowPlayingHeaderView.superview.superview.superview;
	if ([superDuperView isMemberOfClass:[NSClassFromString(@"CSMediaControlsView") class]]) {
		CGRect originalRouteRect = routeButton.frame;
		CGRect padlockFrame =  CGRectMake(originalRouteRect.origin.x + 8, originalRouteRect.origin.y-originalRouteRect.size.height + 5, originalRouteRect.size.width - 16, originalRouteRect.size.height - 10);
	
		if (!padlockView) {
			currentProgress = 0.00f;
			
			padlockView = [[LockView alloc] initWithFrame:padlockFrame];
			
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    		[padlockView addGestureRecognizer:tapGesture];
    		
			[self.nowPlayingHeaderView addSubview: padlockView];
		}
		[padlockView setFrame: padlockFrame];
	}
}

%new
- (void)tap:(id)sender {
    // Run a fixed animation to (un)lock depending on current progress
    if (padlockView.progress < 1.0) {
        padlockView.progress = 0;
        currentProgress = 0.0;
        
        [self performSelector:@selector(animatePadlockViewWithDuration:andDestination:) withObject:[NSNumber numberWithFloat: 18.0] withObject:[NSNumber numberWithFloat: 1.0]]; //Write the time you intend, times x60. No idea why.
    }
    else {
        currentProgress = 1.0;
        [self performSelector:@selector(animatePadlockViewWithDuration:andDestination:) withObject:[NSNumber numberWithFloat: 18.0] withObject:[NSNumber numberWithFloat: 0.0]]; //Write the time you intend, times x60. No idea why.
    }
    
}

%new
- (void)animatePadlockViewWithDuration:(NSNumber *)durationObj andDestination:(NSNumber *)destinationObj {
	CGFloat duration = [durationObj floatValue];
	CGFloat destination = [destinationObj floatValue];
    [UIView animateWithDuration:0.01 animations:^{
        padlockView.progress = currentProgress;
    } completion:^(BOOL finished) {
        /* Destination is either 1, or 0, so we can base our decisions here*/
        //The step is 0.01 divided by total duration, multiplied by the destination, which is 1 (or a decrease by 1 so it can be skipped as a neutral multiplier).
        CGFloat animationProgress = 100 * fabs(destination - currentProgress); //This when complete will approach 0. So when times 100, it's less than 1, it's complete
        if (animationProgress > 1) {
            CGFloat stepValue = 0.01 / duration;
            if (destination == 1.0) {
                //This means values go up.
                currentProgress += stepValue;
            }
            else {
                //This means we must go to 0.
                currentProgress -= stepValue;
            }
            [self performSelector:@selector(animatePadlockViewWithDuration:andDestination:) withObject:durationObj withObject:destinationObj];
        }
        else {
            padlockView.progress = destination;
        }
    }];
}

%end

