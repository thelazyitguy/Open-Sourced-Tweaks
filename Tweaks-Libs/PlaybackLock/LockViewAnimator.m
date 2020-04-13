//
//  LockViewAnimator.m
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import "LockViewAnimator.h"
#import "LockView.h"

@implementation LockViewAnimator

- (CGFloat)progress {
    if (self.lockView == nil) {
        return 0.0f;
    }
    LockView *lView = (LockView *) self.lockView;
    return lView.progress;
    
}

- (void)setProgress:(CGFloat)progress {
    if (self.lockView != nil) {
        LockView *lView = (LockView *) self.lockView;
        lView.progress = progress;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.threshold = 0.01f;
    }
    return self;
}

@end
