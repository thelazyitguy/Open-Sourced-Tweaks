#import "HPTutorialViewController.h"
#import "EditorManager.h"
#import "HPResources.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation HPTutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.alpha = 1;
}

- (void)introView
{
    self.viewOne = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 150, 42)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,150,42)];
    imageView.image = [HPResources tutorialOne];
    [self.viewOne addSubview:imageView];
    [self.view addSubview:self.viewOne];
}

- (void)explainExit
{
    self.viewOne.alpha = 0;
    self.viewOne.hidden = YES;
    self.viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.viewTwo.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    imageView.image = [HPResources tutorialTwo];
    [self.viewTwo addSubview:imageView];
    self.viewTwo.alpha = 0.99;
    [self.view addSubview:self.viewTwo];
    [UIView animateWithDuration:1
        animations:
        ^{  
            self.viewTwo.alpha = 1;
        }
        completion:^(BOOL finished) 
        {
            [UIView animateWithDuration:0.4 
                animations:
                ^{  
                    self.viewTwo.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -200);
                    self.viewTwo.alpha = 0; 
                }
            ];
        }
    ]; 

}


@end