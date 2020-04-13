#import <UIKit/UIKit.h>

@interface _UILegibilityView : UIView
	-(UIImageView *)imageView;
@end

%hook UIPageControl
-(double)_modernCornerRadius {
	return 1;
}

%end