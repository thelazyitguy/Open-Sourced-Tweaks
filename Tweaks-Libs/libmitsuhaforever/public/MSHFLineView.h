#import "MSHFJelloLayer.h"
#import "MSHFView.h"
#import <UIKit/UIKit.h>

@interface MSHFLineView : MSHFView

@property(nonatomic, assign) CGFloat lineThickness;
@property(nonatomic, strong) MSHFJelloLayer *waveLayer;

- (CGPathRef)createPathWithPoints:(CGPoint *)points
                       pointCount:(NSUInteger)pointCount
                           inRect:(CGRect)rect;

@end