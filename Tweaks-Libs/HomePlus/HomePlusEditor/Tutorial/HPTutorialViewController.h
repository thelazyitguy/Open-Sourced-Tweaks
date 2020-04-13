#include <UIKit/UIKit.h>

@interface HPTutorialViewController : UIViewController 
@property (nonatomic, retain) UIView *viewOne;
@property (nonatomic, retain) UIView *viewTwo;
@property (nonatomic, retain) UIView *viewThree;
@property (nonatomic, retain) UIView *viewFour;
@property (nonatomic, retain) UIView *viewFive;
@property (nonatomic, retain) UIView *viewSix;
@property (nonatomic, retain) UIView *viewSeven;

- (void)introView;
- (void)explainExit;
@end