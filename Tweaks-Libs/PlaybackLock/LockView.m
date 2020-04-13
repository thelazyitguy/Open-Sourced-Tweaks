//
//  LockView.m
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import "LockView.h"

@implementation LockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.shackleLayer = [[CAShapeLayer alloc] init];
        self.bodyLayer = [[CAShapeLayer alloc] init];
        self.shacklePath = [[UIBezierPath alloc] init];
        self.progress = 0.00f; // 0.0 being locked, 1.0 being unlocked
        self.animator = [[LockViewAnimator alloc] init];
        

        self.shackleLayer.frame = self.bounds;
        self.bodyLayer.frame = self.bounds;
        [self.layer addSublayer:self.shackleLayer];
        [self.layer addSublayer:self.bodyLayer];

        CGFloat bodyCornerRadius = 0.15 * self.frame.size.width;
        CGFloat bodyWidth  = self.bodyLayer.bounds.size.width;
        CGFloat bodyHeight = 0.6 * self.bodyLayer.bounds.size.height;
        CGFloat bodyY      = self.bodyLayer.bounds.size.height - bodyHeight;

        [self updateShacklePath];

        UIBezierPath *bodyPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, bodyY, bodyWidth, bodyHeight) cornerRadius:bodyCornerRadius];
        self.bodyLayer.path = [bodyPath CGPath];
        self.bodyLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor; // tweak me to see inside the lock
        self.bodyLayer.strokeColor = [[UIColor clearColor] CGColor];

        // See: LockViewAnimator notes
        self.animator.lockView = self;
    }
    return self;
}

// 0.0 being locked, 1.0 being unlocked
- (void)setProgress:(CGFloat)progress {
    // If it ain't changed, don't animate it.
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    [self updateShacklePath];
}

/*
 * Draws the "shackle" or the moving, swingy bit of the lock.
 */
- (void)updateShacklePath {

    // Defines how much of the animation is devoted to the shackle first lifting up out of the lock
    // 0.2 means the shackle will lift up and out for the first 20% of the animation and swing for the last 80%
    CGFloat shackleLiftKeytime = 0.2;
    // Calulates when the shackle will be mid swing and nudges it forward a bit to avoid a visual glitch
    // where the overlapping lines are perfectly on top of one another and we'll lose our nice round end cap
    // Remove and scrub through the animation slowly to see!
    CGFloat shackleSwingHalfWayKeytime = (shackleLiftKeytime + ((1.0 - shackleLiftKeytime) / 2.0));
    if (fabs(self.progress - shackleSwingHalfWayKeytime) < 0.01) {
        self.progress = self.progress + 0.01;
    }

    CGFloat shackleLineWidth = (0.10 * self.frame.size.width);
    CGFloat lockCurveWidth   = ((0.79 / 2.0) * self.shackleLayer.bounds.size.width) - (shackleLineWidth / 2.0);
    // The total height of the shackle including the straight and curved bits
    CGFloat lockTotalHeight  = 0.4 * self.shackleLayer.bounds.size.height - shackleLineWidth;
    CGFloat lockCurveHeight  = 0.65 * lockTotalHeight;
    CGFloat lockStraightHeight = 0.35 * lockTotalHeight + shackleLineWidth; // extra bit to prevent visual gapping
    // How far from the edges the shackle is inset
    CGFloat shackleInset = (self.shackleLayer.bounds.size.width - (2 * lockCurveWidth)) / 2.0;
    // How far the "fixed" part of the shackle extends into the lock body
    CGFloat shackleInsetExtra  = shackleInset;

    // This splits the progress value around the shackleLiftKeytime point and creates two values
    // that range from 0...1 so we can more easily animate the rest of the bits.
    // Now we can reliably use these values to know if the shackle should be all the way lifted
    // For example if shackleLiftKeytime is 0.2 then when progress is 0.15 shackleLiftProgress will be 0.75,
    // and shackleSwingProgress will be 0.0.
    CGFloat shackleLiftProgress = fmin(fmax((self.progress/shackleLiftKeytime), 0.0), 1.0);
    CGFloat shackleSwingProgress = fmin(fmax((self.progress - shackleLiftKeytime) / (1.0 - shackleLiftKeytime), 0.0), 1.0);

    // These are used for moving around to draw the shackle from bottom left up to the apex of the curve and back down
    CGFloat topY    = (shackleLineWidth / 2.0); // inset half the stroke width to prevent clipping
    topY = topY - (shackleLiftProgress * shackleInsetExtra); // moves the shackle up
    // Determines the changing horizontal position of moving side of the shackle and its center for curve calculations
    CGFloat leftX   = shackleInset + (shackleSwingProgress * 4 * lockCurveWidth);
    CGFloat centerX = shackleInset + lockCurveWidth + (shackleSwingProgress * 2 * lockCurveWidth);
    CGFloat rightX  = shackleInset + (2.0 * lockCurveWidth);

    [self.shacklePath removeAllPoints]; // Necessary since we update the path
    // Move to the lowest point of the left/shortest side of the shackle
    [self.shacklePath moveToPoint:CGPointMake(leftX, topY + lockStraightHeight + lockCurveHeight)];
    // Draw the straight part of the short side of the shackle
    [self.shacklePath addLineToPoint:CGPointMake(leftX, topY + lockCurveHeight)];
    
    // Draw one side of the curve
    [self.shacklePath addCurveToPoint:CGPointMake(centerX, topY) controlPoint1:CGPointMake(leftX, topY + lockCurveHeight) controlPoint2:CGPointMake(leftX, topY)];
    // Draw the other side of the curve
    [self.shacklePath addCurveToPoint:CGPointMake(rightX, topY + lockCurveHeight) controlPoint1:CGPointMake(rightX, topY) controlPoint2:CGPointMake(rightX, topY + lockCurveHeight)];
    // Draw the long side of the shackle
    [self.shacklePath addLineToPoint:CGPointMake(rightX, topY + lockCurveHeight + lockStraightHeight)];
    // Draw the extra bit that makes it longer (seperated for clarity)
    [self.shacklePath addLineToPoint:CGPointMake(rightX, topY + lockCurveHeight + lockStraightHeight + shackleInsetExtra)];
    self.shackleLayer.path        = [self.shacklePath CGPath];
    self.shackleLayer.strokeColor = [[UIColor whiteColor] CGColor];
    self.shackleLayer.fillColor   = [[UIColor clearColor] CGColor];
    self.shackleLayer.lineWidth   = shackleLineWidth;
    self.shackleLayer.lineCap     = kCALineCapRound;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
