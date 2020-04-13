//
//  LockView.h
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockViewAnimator.h"

@class LockViewAnimator;

NS_ASSUME_NONNULL_BEGIN

@interface LockView : UIView

@property (nonatomic) CGFloat progress; // 0.0 being locked, 1.0 being unlocked
@property CAShapeLayer *shackleLayer;
@property CAShapeLayer *bodyLayer;
@property UIBezierPath *shacklePath;
@property LockViewAnimator *animator;

@end


NS_ASSUME_NONNULL_END
