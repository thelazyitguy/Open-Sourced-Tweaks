#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "NSTask.h"

@interface AXNPrefsListController : PSListController {
    UITableView * _table;
}
@property (nonatomic, assign) BOOL loadHeaderView;
@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;

- (void)respring:(id)sender;

@end

@interface AXNLayoutListController : AXNPrefsListController
@end 
@interface AXNColorsListController : AXNPrefsListController
@end 
@interface AXNSortingListController : AXNPrefsListController
@end 
