//
//  LockViewAnimator.h
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockViewAnimator : NSObject

@property (weak, nonatomic) id lockView;
@property CGFloat threshold;
@property CGFloat progress;

@end

NS_ASSUME_NONNULL_END
