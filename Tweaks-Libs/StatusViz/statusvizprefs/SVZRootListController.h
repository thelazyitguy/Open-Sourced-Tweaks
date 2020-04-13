#import <Preferences/PSListController.h>

@interface SVZRootListController : PSListController

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *overflowView;
@property (nonatomic, assign) CGFloat startContentOffset;
@property (nonatomic, assign) BOOL kick;
@property (nonatomic, assign) BOOL showHeader;

@end
