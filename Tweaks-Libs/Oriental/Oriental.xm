#import "Oriental.h"

UIWindow *orientalWindow;
UIView *orientalView;
UITapGestureRecognizer *tapToToggleLock = nil;
UIBlurEffect *blurEffect;
UIVisualEffectView *blurEffectView;
CCUICAPackageView *glyphView;

extern NSString const *kCAPackageTypeCAMLBundle;
static CGFloat screenHeight;
static CGFloat screenWidth;
BOOL isLocked;
BOOL isShowing = NO;
BOOL ENABLED = YES;

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    if (ENABLED) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        screenSize = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;

        orientalWindow = [[UIWindow alloc] initWithFrame:CGRectMake(20, screenHeight-70, 50, 50)];
        orientalWindow.backgroundColor = [UIColor clearColor];
        orientalWindow.windowLevel = 100002;
        orientalWindow.hidden = YES;
        orientalWindow.alpha = 0.0;
        orientalWindow.autoresizesSubviews = YES;
        [orientalWindow _setSecure:YES];
        [orientalWindow setUserInteractionEnabled:YES];

        orientalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        orientalView.layer.cornerRadius = 10.0;
        orientalView.layer.masksToBounds = YES;
        [orientalView setBackgroundColor:[UIColor clearColor]];
        [orientalView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [orientalView setUserInteractionEnabled:YES];
        
        blurEffectView.alpha = 1.0;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = orientalView.bounds;
        [orientalView addSubview:blurEffectView];

        glyphView = [[%c(CCUICAPackageView) alloc] initWithFrame:orientalView.bounds];
        glyphView.package = [CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:@"/System/Library/ControlCenter/Bundles/OrientationLockModule.bundle/OrientationLock.ca"] type:kCAPackageTypeCAMLBundle options:nil error:nil];
        [orientalView addSubview:glyphView];
        [glyphView.centerXAnchor constraintEqualToAnchor:orientalView.centerXAnchor].active = YES;
        [glyphView.centerYAnchor constraintEqualToAnchor:orientalView.centerYAnchor].active = YES;

        tapToToggleLock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLock:)];
        [orientalView addGestureRecognizer:tapToToggleLock];
        [tapToToggleLock release];
        [orientalWindow addSubview:orientalView];
    }
}

%new
- (void)toggleLock:(UITapGestureRecognizer *)gestureRecognizer {
    if (isLocked) {
        [[%c(SBOrientationLockManager) sharedInstance] unlock];
    } else {
        [[%c(SBOrientationLockManager) sharedInstance] lock];
    }
}
%end

%hook SBSceneView
- (void)_setOrientation:(long long)orientation {
    if (ENABLED && !isShowing && (orientation == 3 || orientation == 4)) {
        if (orientation == 3) { //landscape right
            CGAffineTransform rotate = CGAffineTransformMakeRotation(90 * M_PI/180);
            CGAffineTransform scale = CGAffineTransformMakeScale(0.75, 0.75);
            CGAffineTransform transform = CGAffineTransformConcat(rotate, scale);
            glyphView.transform = transform;

            CGAffineTransform move  = CGAffineTransformMakeTranslation(0, 0);
            orientalWindow.transform = move;
        }
        if (orientation == 4) { //landscape left
            CGAffineTransform rotate = CGAffineTransformMakeRotation(-90 * M_PI/180);
            CGAffineTransform scale = CGAffineTransformMakeScale(0.75, 0.75);
            CGAffineTransform transform = CGAffineTransformConcat(rotate, scale);
            glyphView.transform = transform;

            CGAffineTransform move  = CGAffineTransformMakeTranslation(+screenWidth-90, -screenHeight+90);
            orientalWindow.transform = move;
        }

        orientalWindow.hidden = NO;
        isShowing = YES;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            orientalWindow.alpha = 1.0;
        } completion:^(BOOL finished) {
            double delayInSeconds = 2.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                    orientalWindow.alpha = 0.0;
                } completion:^(BOOL finished) {
                    isShowing = NO;
                }];
            });
        }];
    } else if (ENABLED && isShowing && (orientation != 3 && orientation != 4)) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            orientalWindow.alpha = 0.0;
        } completion:^(BOOL finished) {
            isShowing = NO;
        }];
    }
    %orig;
}
%end

%hook SBOrientationLockManager
- (BOOL)isUserLocked {
    if (isLocked != %orig) {
        if (!%orig) {
            [orientalView setBackgroundColor:[UIColor clearColor]];
            blurEffectView.alpha = 1.0;
        } else {
            [orientalView setBackgroundColor:[UIColor whiteColor]];
            blurEffectView.alpha = 0.0;
        }
    }
    isLocked = %orig;
    return %orig;
}
- (void)unlock {
    if (ENABLED) {
        [orientalView setBackgroundColor:[UIColor clearColor]];
        blurEffectView.alpha = 1.0;
    }
    %orig;
}
- (void)lock {
    if (ENABLED) {
        [orientalView setBackgroundColor:[UIColor whiteColor]];
        blurEffectView.alpha = 0.0;
    }
    %orig;
}
%end